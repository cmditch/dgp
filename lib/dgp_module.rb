module DGP
  require 'blockcypher'


  API_SLEEP_TIME = 0.4
  CURRENCY = "btc"
  BLOCKCYPHER_API_TOKEN = Rails.application.secrets.blockcypher_api_token
  CONVERT_CURRENCY = Proc.new do |type, x|
    case type.downcase
    when "eth"
      x.to_f / 10**16
    when "btc"
      x.to_f / 10**8
    end
  end

  def self.bitpay_pair
    p BitPay::SDK::Client.new(pem: Rails.application.secrets.bitpay_pem).pair_client.first["pairingCode"]
  end

  class MarketData
    require 'coinbase/wallet'

    KEY     = Rails.application.secrets.coinbase_api_key
    SECRET  = Rails.application.secrets.coinbase_api_secret

    class << self

      def update_usd_btc_spot_price
        if Global.first
          Global.first.update(btc_usd_spot_price: api.spot_price({currency_pair: 'BTC-USD'})["amount"].to_f)
        else
          0
        end
      end

      def historical_spot_price(date=Date.today.to_s)
        date = date.to_s
        price = api.spot_price({currency_pair: 'BTC-USD', date: date})
        price["amount"].to_f
      end

      def usd_btc_spot_price
        if Global.first
          Global.first.btc_usd_spot_price
        else
          0
        end
      end

      private

      def api
        Coinbase::Wallet::Client.new(api_key: KEY, api_secret: SECRET)
      end

    end
  end

  class TransactionsFactory
    attr_accessor :wallet_id

    def initialize(txs)
      @txs = txs
    end

    def save
      @txs.each do |raw_tx|
        raw_tx[:txid]       = raw_tx.delete(:hash)
        raw_tx[:wallet_id]  = wallet_id
        tx = Transaction.new
        tx.attributes = raw_tx.reject{ |k,v| !tx.attributes.keys.member?(k.to_s) }
        tx.usd_spot_price = DGP::MarketData.historical_spot_price(tx.received.to_date.to_s)
        sleep 0.35
        unless Transaction.find_by(txid: raw_tx[:txid])
          if tx.save then p "[DGP-NOTIFY] Created Transaction. txid: #{tx.txid}" else p "[DGP-NOTIFY] Error adding transaction. txid: #{raw_tx[:txid]}" end
          tx.validate
        end
      end
    end
  end

end #module DGP

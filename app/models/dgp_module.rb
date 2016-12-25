module DGP
  require 'blockcypher'

  CONVERT_CURRENCY = Proc.new do |type, x|
    case type
    when "eth"
      x.to_f / 10**16
    when "btc"
      x.to_f / 10**8
    end
  end

  class ChainParser
    def initialize(wallet)
      @wallet = wallet
      @convert = CONVERT_CURRENCY.curry.(@wallet.currency)
    end

    def details
      api.address_details(@wallet.address)
    end

    def txs
      details["txrefs"]
    end

    def new_tx_ids
      (txs.map { |tx| tx["tx_hash"] } - @wallet.tx_ids).reverse
    end

    def blockchain_transaction(tx)
      api.blockchain_transaction(tx)
    end

    def update_database
      begin
        new_tx_ids.each do |new_tx|
          tx = api.blockchain_transaction(new_tx)
          txid                = new_tx
          sender_addresses    = tx["inputs"].map {|sender| sender["addresses"]}.flatten
          receiving_addresses = tx["outputs"].map {|receiver| receiver["addresses"]}.flatten
          amount              = tx["total"]
          fee                 = tx["fees"]
          time                = tx["received"]
          block               = tx["block_height"]

          transaction_params = {
            txid: txid,
            sender: sender_addresses,
            recipient: receiving_addresses,
            amount: @convert.(amount),
            time: time.to_datetime,
            block_id: block,
            fee: fee,
            currency: @wallet.currency
          }
          Transaction.create(transaction_params)
          sleep 0.3
        end
      rescue => e
        puts "[ERROR] Updating transactions failed. WalletID: #{@wallet.id} TxId: #{txid}"
      end
    end

    private

    def api
      BlockCypher::Api.new(currency: @wallet.currency)
    end
  end #class ChainParser

  class Depositor
    require 'coinbase/wallet'
    KEY = Rails.application.secrets.coinbase_api_key
    SECRET = Rails.application.secrets.coinbase_api_secret
    client = Coinbase::Wallet::Client.new(api_key: KEY, api_secret: SECRET)

  end #class Depositor
end #module DGP

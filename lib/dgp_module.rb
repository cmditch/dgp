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

  class TransactionFactory

    def initialize(txs)
      @txs = txs
    end

    def save
      @txs.each do |raw_tx|
        raw_tx[:txid] = raw_tx.delete(:hash)
        tx = Transaction.new
        tx.attributes = raw_tx.reject{ |k,v| !tx.attributes.keys.member?(k.to_s) }
        if Transaction.find_by(txid: raw_tx[:txid])
          p "[DGP-NOTIFY] TX already exists in database. txid: #{raw_tx[:txid]}"
        else
          if tx.save then p "[DGP-NOTIFY] Created Transaction. txid: #{tx.txid}" else p "[DGP-NOTIFY] Error adding transaction. txid: #{raw_tx[:txid]}" end
        end
      end
    end

  end


  class ChainParser

    class << self
      def api
        BlockCypher::Api.new(api_token: BLOCKCYPHER_API_TOKEN)
      end

      def address_details(address)
        api.address_details(address)
      end

      def address_balance(address)
        api.address_balance(address)
      end

      def address_full_txs(address)
        api.address_full_txs(address)
      end

      def tx(tx)
        api.blockchain_transaction(tx)
      end
    end

    def initialize(wallet)
      @wallet = wallet
      @convert = CONVERT_CURRENCY.curry.(@wallet.currency)
    end

    def api
      BlockCypher::Api.new(currency: @wallet.currency, api_token: BLOCKCYPHER_API_TOKEN)
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

    def tx(tx)
      api.blockchain_transaction(tx)
    end

    def update_database
      new_tx_ids.each do |new_tx|
        begin
          tx = api.blockchain_transaction(new_tx)
          txid                = new_tx
          sender_addresses    = tx["inputs"].map {|sender| sender["addresses"]}.flatten
          receiving_addresses = tx["outputs"].map {|receiver| receiver["addresses"]}.flatten
          amount              = tx["total"]
          fee                 = tx["fees"]
          time                = tx["received"]
          block               = tx["block_height"]

          transaction_params = {
            txid:       txid,
            sender:     sender_addresses,
            recipient:  receiving_addresses,
            amount:     @convert.(amount),
            time:       time.to_datetime,
            block_id:   block,
            fee:        fee,
            currency:   @wallet.currency
          }

          Transaction.create(transaction_params)
          sleep 0.3
        rescue => e
          Rails.logger.info "[ERROR] Updating transactions failed. WalletID: #{@wallet.id} TxId: #{txid}\n#{e}"
        end
      end
    end
  end #class ChainParser





end #module DGP

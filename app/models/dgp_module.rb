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

    def api
      BlockCypher::Api.new(currency: @wallet.currency)
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

  class Depositor
    require 'coinbase/wallet'

    KEY         = Rails.application.secrets.coinbase_api_key
    SECRET      = Rails.application.secrets.coinbase_api_secret
    ACCOUNT_ID  = Rails.application.secrets.coinbase_account_id

    def initialize(wallet)
      @wallet   = wallet
      @address  = @wallet.addresses
      @client   = @wallet.transactor
      @amount   = @wallet.transactor.daily_usd_amount
      @api      = Coinbase::Wallet::Client.new(api_key: KEY, api_secret: SECRET)
      @account  = @api.account(ACCOUNT_ID)
    end

    def deposit
      if @client.active? && @wallet.primary?
        @account.send(to: @address, amount: @amount, currency: "USD")
      else
        Rails.logger.info "[ERROR] Deposit failed. ClientID: #{@client.id}  WalletID: #{@wallet.id}"
      end
    end

  end #class Depositor
end #module DGP

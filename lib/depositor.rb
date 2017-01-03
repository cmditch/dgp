  module Depositor

    class Client

      require 'coinbase/wallet'

      attr_accessor :success
      
      KEY         = Rails.application.secrets.coinbase_api_key
      SECRET      = Rails.application.secrets.coinbase_api_secret
      ACCOUNT_ID  = Rails.application.secrets.coinbase_account_id

      def initialize(client)
        @client   = client
        @wallet   = @client.primary_wallet
        @address  = @wallet.address
        @amount   = @client.daily_usd_amount
        @api      = Coinbase::Wallet::Client.new(api_key: KEY, api_secret: SECRET)
        @account  = @api.account(ACCOUNT_ID)
      end

      def deposit
        if @client.active? && @wallet.primary?
          @account.send(to: @address, amount: @amount, currency: "USD")
          self.success = true
          @api = nil
        else
          puts "[ERROR] Deposit failed.\nClientID: #{@client.id} (active: #{@client.active})  WalletID: #{@wallet.id} (primary: #{@wallet.primary})"
        end
      end

    end #class Client
  end #module Depositor
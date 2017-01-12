  module Depositor

    class Client

      require 'coinbase/wallet'

      attr_accessor :success

      def initialize(client)
        @key         = Rails.application.secrets.coinbase_api_key
        @secret      = Rails.application.secrets.coinbase_api_secret
        @account_id  = Rails.application.secrets.coinbase_account_id
        @client      = client
        @address     = @client.primary_wallet
        @amount      = @client.daily_usd_amount
        @api         = Coinbase::Wallet::Client.new(api_key: @key, api_secret: @secret)
        @account     = @api.account(@account_id)
      end

      def deposit
        if @client.active?
          if @account.send(to: @address, amount: @amount, currency: "USD")
            self.success = true
            puts "[DGP-NOTIFY] Depositing to #{@client.name} (#{@client.id}) success!"
            @api = nil
            @client.total_donations += @amount
            @client.save
          end
        else
          puts "[DGP-ERROR] Deposit to #{client.name} (#{client.id}) FAILED! "
        end
      end

    end #class Client
  end #module Depositor
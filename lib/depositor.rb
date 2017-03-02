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
        @wallet_balance  = client.balance * Global.first.btc_usd_spot_price
      end

      def deposit
        if @client.active? && @wallet_balance <= 41
          if @account.send(to: @address, amount: @amount, currency: "USD")
            self.success = true
            puts "[DGP-NOTIFY] Depositing $#{@amount} to #{@client.name} (#{@client.id}) success!"
            @api = nil
            @client.total_donations += @amount
            @client.save
          else
            puts "[DGP-ERROR] Deposit to #{client.name} FAILED! Balance is: #{@wallet_balance} "
          end
        end
      end

      def test_deposit
        test_deposit_amount = Rails.application.secrets.test_deposit_amount
        if @account.send(to: @address, amount: test_deposit_amount, currency: "USD")
          self.success = true
          @client.test_deposit_made = true
          @client.total_donations += test_deposit_amount
          puts "[DGP-NOTIFY] Test deposit sent to #{@client.name} (#{@client.id})"
          @api = nil
          @client.save
        else
          puts "[DGP-ERROR] Test deposit to #{client.name} (#{client.id}) FAILED!"
        end
      end

    end #class Client
  end #module Depositor
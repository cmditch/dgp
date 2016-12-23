module ChainParser
  require 'blockcypher'

    def self.parse_btc(wallet)
      begin
        api = BlockCypher::Api.new(currency: wallet.currency)
        txs = api.address_details(wallet.address)["txrefs"]

        # [REFAC] delete recorded transactions before calling api below

        txs.each do |tx_load|
          sleep 0.2
          tx = api.blockchain_transaction(tx_load["tx_hash"])
          txid                = tx_load["tx_hash"]
          sender_addresses    = tx["inputs"].map {|sender| sender["addresses"]}.flatten
          receiving_addresses = tx["outputs"].map {|receiver| receiver["addresses"]}.flatten
          amount              = tx["total"]
          fee                 = tx["fees"]
          time                = tx["received"]
          block               = tx["block_height"]

            transaction_params  = {
            txid: txid,
            sender: sender_addresses,
            recipient: receiving_addresses,
            amount: amount,
            time: time.to_datetime,
            block_id: block,
            fee: fee,
            currency: "btc"
          }
          unless Transaction.list.include?(transaction_params[:txid])
            Transaction.create(transaction_params)
          end
        end
      rescue => e
        puts "!!! Parsing failed for WalletID: #{wallet.id} !!!"
      end
    end

end

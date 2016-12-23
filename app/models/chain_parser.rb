module ChainParser
  require 'blockcypher'

    def self.btc_parse(wallet)
      api = BlockCypher::Api.new(currency: wallet.currency)
      tx_hashes = api.address_details(wallet.address)["txrefs"]
      puts tx_hashes

      tx_hashes.each do |tx_load|
        puts tx = api.blockchain_transaction(tx_load["tx_hash"])
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
          time: Time.new(time),
          block_id: block,
          fee: fee
        }
        unless Transaction.list.include?(transaction_params[:txid])
          Transaction.create(transaction_params)
        end
      end
    end

end

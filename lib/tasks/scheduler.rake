require 'dgp_module'

desc "This task adds recent BTC txs to the list"
task :scrape_the_chain => :environment do
  puts "Updating tx feed..."
  Client.all.each do |client|
    client.wallets.each do |wallet|
      DGP::ChainParser.new(wallet).update_database
      puts "Finished parsing transactions for WalletID: #{wallet.id}"
    end
  end
  puts "done."
end


desc "Deposit daily USD to primary wallets of active clients"
task :daily_deposit => :environment do
  puts "Beginning deposits"
  # Rails.logger.info "Beginning deposits.."
  Client.active.each do |client|
    # Rails.logger.info "Depositing to Client   { id: #{client.id}, name: #{client.name}, wallet: #{client.primary_wallet} }"
    puts "Depositing to    { ID: #{client.id}, NAME: #{client.name} }"
    depositor = DGP::Depositor::Client.new(client)
    depositor.deposit
    # Rails.logger.info "Deposit Success Client { id: #{client.id}, name: #{client.name}, wallet: #{client.primary_wallet} }"
    puts "Deposit Success! { id: #{client.id}, name: #{client.name}, wallet: #{client.primary_wallet.address} }" if depositor.success
  end
end


desc "Updates database with latest client wallets and transactions"
task :update_client_wallets => :environment do
  blockcypher_request = BlockCypher::Api.new(api_token: DGP::BLOCKCYPHER_API_TOKEN)
  Client.all.each do |client|
    ["primary_wallet", "change_wallet"].each do |type|
      n = 0
      loop do
        address               =   client.send("#{type}", n)
        wallet                =   Wallet.find_by(address: address)
        wallet_block_height   =   wallet.last_block_height unless wallet.nil?
        endpoint_data         =   blockcypher_request.address_full_txs(address, after: wallet_block_height).deep_symbolize_keys
        tx_block_height       =   endpoint_data[:txs].map{ |tx| tx[:block_height] }.max
        extra_wallet_details  =   { transactor_id: client.id, transactor_type: "Client", currency: "btc", wallet_type: type, hd_position: n, last_block_height: tx_block_height + 1 }
        endpoint_data.merge!(extra_wallet_details)
        DGP::TransactionFactory.new(endpoint_data[:txs]).save unless endpoint_data[:txs].empty?
        unless endpoint_data[:final_n_tx] == 0
          if wallet.nil?
            w = Wallet.create(endpoint_data)
            p "[DGP-NOTIFY] #{type} #{w.address} created for client #{w.transactor.id} (#{w.transactor.name})"
          else
            wallet.update(endpoint_data)
            p "[DGP-NOTIFY] #{type} #{wallet.address} updated for client #{wallet.transactor.id} (#{wallet.transactor.name})"
          end
        end

        n += 1
        sleep DGP::API_SLEEP_TIME
        break if endpoint_data[:final_n_tx] == 0
      end #end of loop
    end #each wallet type iterated
  end #each client iterated
end

#Dear GitHub Viewers, this is a super fast prototype. Sorry for the slop. - cditch





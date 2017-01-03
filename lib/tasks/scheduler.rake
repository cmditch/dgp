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


desc "Updates database with latest client wallets"
task :update_client_wallets => :environment do
  api = BlockCypher::Api.new(api_token: DGP::BLOCKCYPHER_API_TOKEN)
  Client.all.each do |client|
    ["primary_wallet", "change_wallet"].each do |type|
      n = 0
      loop do
        client_wallet_details = {transactor_id: client.id, transactor_type: "Client", currency: "btc", wallet_type: type, hd_position: n}
        address = client.send("#{type}", n)
        wallet_info = api.address_full_txs(address).deep_symbolize_keys
        wallet = Wallet.find_by(address: address)
        unless wallet_info[:final_n_tx] == 0
          if wallet.nil?
            w = Wallet.create(wallet_info.merge(client_wallet_details))
            p "[DGP-NOTIFY] #{type}  #{w.address}  created for client #{w.transactor.id} (#{w.transactor.name})"
          else
            wallet.update(wallet_info.merge(client_wallet_details))
            p "[DGP-NOTIFY] #{type}  #{wallet.address}  updated for client #{wallet.transactor.id} (#{wallet.transactor.name})"
          end
        end
        n += 1
        sleep DGP::API_SLEEP_TIME
        break if wallet_info[:final_n_tx] == 0
      end
    end 
  end
end

#Dear GitHub Viewers, this is a super fast prototype. Sorry for the slop. - cditch





require 'dgp_module'

desc "This task adds recent BTC txs to the list"
task :update_btc_txs => :environment do
  puts "Updating feed..."
  Wallet.all.each do |wallet|
    DGP::ChainParser.new(wallet).update_database
    puts "Finished parsing transactions for WalletID: #{wallet.id}"
  end
  puts "done."
end

desc "Deposit's daily $ amount to primary wallets of active clients"
task :daily_deposit do
  puts "Beginning deposits"
  Rails.logger.info "Beginning deposits.."
  Clients.active.each do |client|
    Rails.logger.info "Depositing to Client   { id: #{client.id}, name: #{client.name}, wallet: #{client.primary_wallet} }"
    depositor = DGP::Depositor.new(client.primary_wallet)
    depositor.deposit
    Rails.logger.info "Deposit Success Client { id: #{client.id}, name: #{client.name}, wallet: #{client.primary_wallet} }"
  end
end

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

# task :send_reminders => :environment do
#   User.send_reminders
# end
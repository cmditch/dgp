desc "This task adds recent BTC txs to the list"
task :update_btc_txs => :environment do
  puts "Updating feed..."
  Wallet.all.each do |wallet|
    ChainParser.parse_btc wallet
    puts "Finished parsing transactions for WalletID: #{wallet.id}"
  end
  puts "done."
end

# task :send_reminders => :environment do
#   User.send_reminders
# end
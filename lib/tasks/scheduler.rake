desc "This task adds recent BTC txs to the list"
task :update_btc_txs => :environment do
  puts "Updating feed..."
  Wallet.each do |wallet|
    ChainParser.parse_btc wallet
  end
  puts "done."
end

# task :send_reminders => :environment do
#   User.send_reminders
# end
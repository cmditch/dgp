module TransactionsHelper

  def recipient_link(tx)
    "https://blockchain.info/address/#{tx.recipient.first}"
  end

  def sender_link(tx)
    "https://blockchain.info/address/#{tx.sender.first}"
  end

end

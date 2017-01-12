module TransactionsHelper

  def short(text)
    "#{text[0..3]}...#{text[-4..-1]}"
  end

  def tx_link(tx)
    "https://blockchain.info/tx/#{tx.txid}"
  end

  def recipient_link(tx)
    "https://blockchain.info/address/#{tx.recipient.first}"
  end

  def sender_link(tx)
    "https://blockchain.info/address/#{tx.sender.first}"
  end

end

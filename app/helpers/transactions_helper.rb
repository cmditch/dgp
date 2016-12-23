module TransactionsHelper

  def short(text)
    "#{text[0..3]}...#{text[-4..-1]}"
  end

  def tx_link(tx)
    case tx.currency
    when "btc"
      "https://blockchain.info/tx/#{tx.txid}"
    end
  end

  def recipient_link(tx)
    case tx.currency
    when "btc"
      "https://blockchain.info/address/#{tx.recipient.first}"
    end
  end

  def sender_link(tx)
    case tx.currency
    when "btc"
      "https://blockchain.info/address/#{tx.sender.first}"
    end
  end

end

class BitpayWebhook < ActiveRecord::Base
  serialize :data
  serialize :transactions

  def client
    tx = Transaction.find_by(txid: txid)
    if tx.nil? then Client.new(name: "Unknown") else tx.transactor end
  end

  def self.tx_ids
    all.map { |x| x.tx_ids }.flatten
  end

  def self.validate_client_txs
    n = 0
    bitpay_invoice_txids = self.all.map(&:transactions).compact.flatten.map { |tx| tx[:txid] }
    bitpay_invoice_txids.each do |invoice_txid|
      if tx = Transaction.find_by(txid: invoice_txid)
        unless tx.validated
          tx.update(validated: true)
          p "[DGP-NOTIFY] Validated tx #{tx.txid} for #{tx.transactor.name}"
          n+=1
        end
      else
        p "[DPG-NOTIFY] Vendor Transaction with non-DGP Client #{invoice_txid}"
      end
    end
    p "[DGP-NOTIFY] #{n} txs validated at #{Time.now}" if n > 0
  end

  def tx_ids
    self.transactions.map { |tx| tx[:txid] }
  end

  def validate_client_txs
    bitpay_invoice_txids = self.transactions.map { |tx| tx[:txid] }  
    bitpay_invoice_txids.each do |invoice_txid|
      if tx = Transaction.find_by(txid: invoice_txid) && !tx.validated
        tx.update(validated: true)
        p "[DGP-NOTIFY] Validated tx #{tx.txid} for #{tx.transactor.name}"
      end
    end
  end

end

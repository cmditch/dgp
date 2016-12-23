class Transaction < ActiveRecord::Base
  serialize :sender
  serialize :recipient


  def self.list
    all.map(&:txid)
  end

  def float_amount
    case self.currency
    when "btc"
      self.amount.to_f / 10**8
    when "eth"
      self.amount.to_f / 10**16
    end
  end 

end

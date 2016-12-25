class Transaction < ActiveRecord::Base
  serialize :sender
  serialize :recipient

  before_save :format_address


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

  private

  def format_address
    puts self.currency
    case self.currency
    when "eth"
      self.sender = self.sender.map { |address| address.prepend("0x") }
      self.recipient = self.recipient.map { |address| address.prepend("0x") }
    end
  end 

end

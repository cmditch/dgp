class Transaction < ActiveRecord::Base
  serialize :addresses
  serialize :inputs
  serialize :outputs
  before_save :format_address
  belongs_to :wallet
  has_one :transactor, through: :wallet, source_type: "Client"

  def self.validate
    before = "Before: #{self.validated?.count} valid. #{self.count - self.validated?.count} not valid."
    all.each(&:validate)
    after  = "After: #{self.validated?.count} valid. #{self.count - self.validated?.count} not valid."
    puts before, after
  end

  def bitpay_tx
    BitpayWebhook.find_by(txid: self.txid)
  end

  def self.list
    all.map(&:txid)
  end

  def self.validated?(x = true)
    where(validated: x)
  end

  def total_usd_price
    (usd_spot_price * (total.to_f / 10**8))
  end

  def fees_usd_price
    (usd_spot_price * (fees.to_f / 10**8))
  end

  def sent_usd_price
    (usd_spot_price * (outputs[-1][:value].to_f / 10**8))
  end

  def sent
    outputs[-1][:value]
  end

  def senders
    self.inputs.map{ |inputs| inputs[:addresses] }.flatten
  end

  def recipients
    self.outputs.map{ |outputs| outputs[:addresses] }.flatten
  end

  def validate
    if non_client_recipients.count < recipients.count && non_client_senders == senders && client_was != "reciever"
      self.update(client_was: "reciever", validated: true)
      true
    elsif non_client_senders.empty?
      params = {client_was: "sender"} 
      self.check_against_bitpay_webhooks ? params[:validated] = true : (params[:validated] = false; p "[DGP-NOTIFY-TX] Transaction #{self.txid} is flagged as invalid!")
      self.update(params)
      # unless !self.transactor.active
      #   self.transactor.update(active: false)
      #   p "[DGP-NOTIFY-TX] #{self.transactor.name.capitalize}'s deposits have been deactivated."
      # end
      true
    else
      self.update(client_was: "Error", validated: false)
      p "[DGP-NOTIFY-TX] Transaction #{self.txid} validation error."
      false
    end
  end

  def check_against_bitpay_webhooks
    BitpayWebhook.find_by(txid: self.txid)
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

  def non_client_senders
    self.senders - self.transactor.used_addresses
  end

  def non_client_recipients
    self.recipients - self.transactor.used_addresses
  end

  def format_address
    case self.currency
    when "eth"
      self.sender = self.sender.map { |address| address.prepend("0x") }
      self.recipient = self.recipient.map { |address| address.prepend("0x") }
    end
  end 

end

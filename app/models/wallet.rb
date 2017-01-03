class Wallet < ActiveRecord::Base
  require 'blockcypher'
  belongs_to :transactor, polymorphic: true
  validates_presence_of :address

  def api
    BlockCypher::Api.new(currency: currency)
  end

  def update_balance
    balance = api.address_balance(address)["balance"]
    case currency
    when "eth"
      self.balance /= 10**16
    when "btc"
      self.balance /= 10**8
    end
    save
  end

  def txs
    address = self.address
    txs = Transaction.all
    txs.map { |tx| tx if [tx.sender, tx.recipient].flatten.include?(address) }.compact
  end

  def tx_ids
    address = self.address
    txs = Transaction.all
    txs.map { |tx| tx.txid if [tx.sender, tx.recipient].flatten.include?(address) }.compact
  end

  def txs_in
    address = self.address
    txs = Transaction.all
    txs.map { |tx| tx if tx.recipient.include?(address) }.compact
  end

  def txs_out
    address = self.address
    txs = Transaction.all
    txs.map { |tx| tx if tx.sender.include?(address) }.compact
  end

  def tx_ids_out
    address = self.address
    txs = Transaction.all
    txs.map { |tx| tx.txid if tx.sender.include?(address) }.compact
  end

  def tx_ids_in
    address = self.address
    txs = Transaction.all
    txs.map { |tx| tx.txid if tx.recipient.include?(address) }.compact
  end

end
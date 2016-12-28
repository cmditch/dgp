class Client < ActiveRecord::Base
  belongs_to :gatekeeper
  has_many :wallets, as: :transactor

  def self.active
    where(active: true)
  end

  def address_list
    wallets.map(&:address)
  end
  
  def primary_wallet
    wallet = self.wallets.where(primary: true)
    if wallet.count > 1
      raise "Client #{self.id} has #{wallet.count} primary wallets."
    elsif wallet.count < 1
      raise "Client #{self.id} has no primary wallet."
    else
      wallet[0]
    end
  end

end

class Client < ActiveRecord::Base
  belongs_to :gatekeeper
  has_many :wallets, as: :transactor

  def address_list
    wallets.map(&:address)
  end
  
  def primary_wallet
    wallet = wallets.where(active: true)
    if wallet.count > 1
      raise "Client #{self.id} has #{wallet.count} primary wallets."
    elsif wallet.count < 1
      raise "Client #{self.id} has no primary wallet."
    else
      wallet[0]
    end
  end
end

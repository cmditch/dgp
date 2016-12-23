class Client < ActiveRecord::Base
  belongs_to :gatekeeper
  has_many :wallets, as: :transactor

  def address_list
    wallets.map(&:address)
  end
  
end

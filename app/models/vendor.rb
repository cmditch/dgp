class Vendor < ActiveRecord::Base
  has_many :wallets, as: :transactor

  def self.address_list
    all.map(&:address_list).flatten
  end

  def address_list
    wallets.map(&:address)
  end

end

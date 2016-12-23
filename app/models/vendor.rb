class Vendor < ActiveRecord::Base
  has_many :wallets, as: :transactor
end

class Client < ActiveRecord::Base
  belongs_to :gatekeeper
  has_many :wallets, as: :transactor
end

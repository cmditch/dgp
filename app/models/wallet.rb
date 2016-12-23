class Wallet < ActiveRecord::Base
  belongs_to :transactor, polymorphic: true
end

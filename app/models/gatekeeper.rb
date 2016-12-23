class Gatekeeper < ActiveRecord::Base
  has_many :users
  has_many :clients
end

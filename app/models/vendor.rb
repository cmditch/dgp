class Vendor < ActiveRecord::Base
  has_many :wallets, as: :transactor
  attr_encrypted :bitpay_pem, key: Rails.application.secrets.encryptor

  def self.address_list
    all.map(&:address_list).flatten
  end

  def address_list
    wallets.map(&:address)
  end

end

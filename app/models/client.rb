class Client < ActiveRecord::Base
  require 'money-tree'
  require 'bip_mnemonic'
  
  has_many :wallets, as: :transactor
  belongs_to :gatekeeper
  attr_encrypted :mnemonic, key: Rails.application.secrets.encryptor

  def self.active
    where(active: true)
  end

  def primary_wallets(index=1)
    index.times.map {|index| hd_master.node_for_path("m/44'/0'/0'/0/#{index}").to_address }
  end

  def change_wallets(index=1)
    index.times.map {|index| hd_master.node_for_path("m/44'/0'/0'/1/#{index}").to_address }
  end
  
  def primary_wallet
    hd_master.node_for_path("m/44'/0'/0'/0/0").to_address
  end

  private

  def seed
    BipMnemonic.to_seed(mnemonic: mnemonic)
  end

  def hd_master
    MoneyTree::Master.new(seed_hex: seed)
  end

end

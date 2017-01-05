class Client < ActiveRecord::Base
  require 'money-tree'
  require 'bip_mnemonic'
  
  has_many :wallets, as: :transactor
  has_many :transactions, through: :wallets
  belongs_to :gatekeeper
  attr_encrypted :mnemonic, key: Rails.application.secrets.encryptor

  def self.active
    where(active: true)
  end

  def primary_wallets(n=1)
    n.times.map {|index| hd_master.node_for_path("m/44'/0'/0'/0/#{index}").to_address }
  end

  def change_wallets(n=1)
    n.times.map {|index| hd_master.node_for_path("m/44'/0'/0'/1/#{index}").to_address }
  end
  
  def primary_wallet(index=0)
    hd_master.node_for_path("m/44'/0'/0'/0/#{index}").to_address
  end

  def change_wallet(index=0)
    hd_master.node_for_path("m/44'/0'/0'/1/#{index}").to_address
  end

  private

  def seed
    BipMnemonic.to_seed(mnemonic: mnemonic)
  end

  def hd_master
    MoneyTree::Master.new(seed_hex: seed)
  end

end

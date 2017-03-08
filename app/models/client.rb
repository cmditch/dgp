class Client < ActiveRecord::Base
  require 'money-tree'
  require 'bip_mnemonic'
  require 'depositor'
  
  has_many :wallets, as: :transactor
  has_many :transactions, through: :wallets
  has_one :seed
  belongs_to :gatekeeper
  attr_encrypted :mnemonic, key: Rails.application.secrets.encryptor

  def self.active
    where(active: true)
  end

  def balance(currency = :btc)
    case currency
    when :usd
      usd_balance
    when :btc
      btc_balance
    end
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

  def used_addresses
    self.wallets.map(&:address)
  end

  def activate
    update(active: true)
  end

  def toggle_activation
    active ? update(active: false) : update(active: true)
  end

  def test_deposit
    Depositor::Client.new(self).test_deposit
  end

  def daily_deposit
    Depositor::Client.new(self).deposit
  end

  def usd_balance
    (btc_balance * Global.first.btc_usd_spot_price).round(2)
  end

  def sent_txs
    transactions.where(client_was: "sender")
  end

  private

  def seed_text
    BipMnemonic.to_seed(mnemonic: mnemonic)
  end

  def hd_master
    MoneyTree::Master.new(seed_hex: seed_text)
  end

  def btc_balance
    wallets.map {|wallet| wallet.final_balance - wallet.unconfirmed_balance}.sum.to_f / (10 ** 8)
  end

  def text_message(text_msg)
    twilio = Twilio::REST::Client.new Rails.application.secrets.twilio_sid, Rails.application.secrets.twilio_token
    if !phone_number.nil?
      twilio.account.messages.create({
          :to => "+1" + phone_number,
          :from => Rails.application.secrets.twilio_number,
          :body => text_msg
      })
    end
  end

end

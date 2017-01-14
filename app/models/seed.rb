class Seed < ActiveRecord::Base
  validates_presence_of :seed
  attr_encrypted :seed, key: Rails.application.secrets.encryptor
  belongs_to :client

  def self.unused
    unused = self.find_by(used: false)
    if unused
      unused
    else
      3.times { Seed.create(seed: BipMnemonic.to_mnemonic(bits: 128)) }
      p "[DGP-NOTIFY] Three new seeds were just generated. Make sure you write these down."
      self.find_by(used: false)
    end  
  end
  
end

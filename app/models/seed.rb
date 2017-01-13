class Seed < ActiveRecord::Base
  validates_presence_of :seed
  attr_encrypted :seed, key: Rails.application.secrets.encryptor
  belongs_to :client

  def self.unused
    self.find_by(used: false)
  end
  
end

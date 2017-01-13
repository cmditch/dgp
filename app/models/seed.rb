class Seed < ActiveRecord::Base
  attr_encrypted :seed, key: Rails.application.secrets.encryptor

  def self.unused
    seed = self.find_by(used: false)
    seed.nil? ? "NO SEEDS LEFT IN LIST, CONTACT DGP" : seed.seed
  end
end

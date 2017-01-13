class Seed < ActiveRecord::Base
  attr_encrypted :seed, key: Rails.application.secrets.encryptor
end

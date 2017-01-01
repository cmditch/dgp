class BitpayWebhook < ActiveRecord::Base
  serialize :data
end

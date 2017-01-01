class AddposDataToBitpayWebhook < ActiveRecord::Migration
  def change
    add_column :bitpay_webhooks, :posData, :string
  end
end

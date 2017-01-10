class AddTxidToBitpayWebhook < ActiveRecord::Migration
  def change
    add_column :bitpay_webhooks, :txid, :string
  end
end

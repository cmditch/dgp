class AddTransactionsToBitpayWebhook < ActiveRecord::Migration
  def change
    add_column :bitpay_webhooks, :transactions, :text
    add_column :bitpay_webhooks, :orderId, :string
  end
end

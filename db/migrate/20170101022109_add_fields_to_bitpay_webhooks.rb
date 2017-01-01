class AddFieldsToBitpayWebhooks < ActiveRecord::Migration
  def change
    add_column :bitpay_webhooks, :invoice_id, :string
    add_column :bitpay_webhooks, :amount, :float
    add_column :bitpay_webhooks, :btcPaid, :float
    add_column :bitpay_webhooks, :currency, :string
    add_column :bitpay_webhooks, :rate, :float
    add_column :bitpay_webhooks, :status, :string
    add_column :bitpay_webhooks, :exceptionStatus, :boolean
  end
end

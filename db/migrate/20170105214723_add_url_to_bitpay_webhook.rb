class AddUrlToBitpayWebhook < ActiveRecord::Migration
  def change
    add_column :bitpay_webhooks, :url, :string
    add_column :bitpay_webhooks, :bitpay_id, :string
    add_column :bitpay_webhooks, :status, :string
    add_column :bitpay_webhooks, :btcPrice, :string
    add_column :bitpay_webhooks, :price, :float
    add_column :bitpay_webhooks, :currency, :string
    add_column :bitpay_webhooks, :invoiceTime, :string
    add_column :bitpay_webhooks, :expirationTime, :string
    add_column :bitpay_webhooks, :currentTime, :string
    add_column :bitpay_webhooks, :btcPaid, :string
    add_column :bitpay_webhooks, :btcDue, :string
    add_column :bitpay_webhooks, :rate, :float
    add_column :bitpay_webhooks, :exceptionStatus, :boolean
    add_column :bitpay_webhooks, :buyerFields, :text
  end
end

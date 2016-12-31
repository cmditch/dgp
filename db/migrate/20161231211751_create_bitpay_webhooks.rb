class CreateBitpayWebhooks < ActiveRecord::Migration
  def change
    create_table :bitpay_webhooks do |t|
      t.text :data

      t.timestamps null: false
    end
  end
end

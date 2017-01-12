class CreateGlobals < ActiveRecord::Migration
  def change
    create_table :globals do |t|
      t.float :btc_usd_spot_price

      t.timestamps null: false
    end
  end
end

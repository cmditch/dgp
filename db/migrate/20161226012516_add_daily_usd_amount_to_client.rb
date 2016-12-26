class AddDailyUsdAmountToClient < ActiveRecord::Migration
  def change
    add_column :clients, :daily_usd_amount, :float
  end
end

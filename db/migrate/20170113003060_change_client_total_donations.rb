class ChangeClientTotalDonations < ActiveRecord::Migration
  def change
    change_column :clients, :total_donations, :float, default: 0.0
    change_column :clients, :active, :boolean, default: true
    change_column :clients, :daily_usd_amount, :float, default: 5.0 
  end
end

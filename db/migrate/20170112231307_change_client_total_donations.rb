class ChangeClientTotalDonations < ActiveRecord::Migration
  def change
    change_column :clients, :total_donations, :float, default: 0.0
  end
end

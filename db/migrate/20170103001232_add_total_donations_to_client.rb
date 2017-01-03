class AddTotalDonationsToClient < ActiveRecord::Migration
  def change
    add_column :clients, :total_donations, :float
  end
end

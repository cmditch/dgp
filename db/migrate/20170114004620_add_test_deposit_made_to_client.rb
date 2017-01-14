class AddTestDepositMadeToClient < ActiveRecord::Migration
  def change
    add_column :clients, :test_deposit_made, :boolean, default: false
  end
end

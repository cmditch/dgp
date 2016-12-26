class AddPrimaryToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :primary, :boolean
  end
end

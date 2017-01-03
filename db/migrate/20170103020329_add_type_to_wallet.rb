class AddTypeToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :wallet_type, :string
    add_column :wallets, :hd_position, :integer
  end
end

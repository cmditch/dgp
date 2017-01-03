class AddTypeToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :wallet_type, :string
    add_column :wallets, :hd_position, :integer
    add_column :wallets, :last_block_height, :integer
    add_column :wallets, :txs, :text
  end
end

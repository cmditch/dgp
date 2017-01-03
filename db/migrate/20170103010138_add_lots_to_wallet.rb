class AddLotsToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :total_received, :integer
    add_column :wallets, :total_sent, :integer
    change_column :wallets, :balance, :integer
    add_column :wallets, :unconfirmed_balance, :integer
    add_column :wallets, :final_balance, :integer
    add_column :wallets, :n_tx, :integer
    add_column :wallets, :unconfirmed_n_tx, :integer
    add_column :wallets, :final_n_tx, :integer
  end
end

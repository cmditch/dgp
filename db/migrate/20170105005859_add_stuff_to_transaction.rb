class AddStuffToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :block_hash, :string
    add_column :transactions, :block_height, :integer
    add_column :transactions, :addresses, :text
    add_column :transactions, :total, :integer
    add_column :transactions, :fees, :integer
    add_column :transactions, :size, :integer
    add_column :transactions, :preference, :string
    add_column :transactions, :relayed_by, :string
    add_column :transactions, :confirmed, :datetime
    add_column :transactions, :received, :datetime
    add_column :transactions, :confirmations, :integer
    add_column :transactions, :inputs, :text
    add_column :transactions, :outputs, :text
    add_reference :transactions, :wallet, index:true 
  end
end

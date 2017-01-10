class AddTypeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :client_was, :string
  end
end

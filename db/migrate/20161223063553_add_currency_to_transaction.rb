class AddCurrencyToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :currency, :string
  end
end

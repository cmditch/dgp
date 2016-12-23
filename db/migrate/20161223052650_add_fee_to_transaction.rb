class AddFeeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :fee, :integer
  end
end

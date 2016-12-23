class ChangeDateFormatInTransactions < ActiveRecord::Migration
  def up
    change_column :transactions, :time, :datetime
  end

  def down
    change_column :transactions, :time, :time
  end
end

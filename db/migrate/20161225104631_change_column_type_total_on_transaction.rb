class ChangeColumnTypeTotalOnTransaction < ActiveRecord::Migration
  def self.up
    change_table :transactions do |t|
      t.change :amount, :float
      t.change :fee, :float
    end
  end
  def self.down
    change_table :transactions do |t|
      t.change :amount, :integer
      t.change :fee, :integer
    end
  end
end

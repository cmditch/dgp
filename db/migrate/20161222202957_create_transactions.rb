class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :txid
      t.string :sender
      t.string :recipient
      t.integer :amount
      t.time :time
      t.integer :block_id

      t.timestamps null: false
    end
  end
end

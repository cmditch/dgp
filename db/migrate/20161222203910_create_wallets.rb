class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :address
      t.float :balance
      t.boolean :active
      t.references :transactor, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end

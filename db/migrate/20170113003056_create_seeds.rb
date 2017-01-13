class CreateSeeds < ActiveRecord::Migration
  def change
    create_table :seeds do |t|
      t.string :encrypted_seed
      t.string :encrypted_seed_iv
      t.boolean :used, default: false
      t.references :client

      t.timestamps null: false
    end
  end
end

class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.references :gatekeeper, index: true

      t.timestamps null: false
    end
    add_foreign_key :clients, :gatekeepers
  end
end

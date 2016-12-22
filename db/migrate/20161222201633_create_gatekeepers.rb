class CreateGatekeepers < ActiveRecord::Migration
  def change
    create_table :gatekeepers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

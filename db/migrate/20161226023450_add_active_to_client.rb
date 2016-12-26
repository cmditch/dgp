class AddActiveToClient < ActiveRecord::Migration
  def change
    add_column :clients, :active, :boolean
  end
end

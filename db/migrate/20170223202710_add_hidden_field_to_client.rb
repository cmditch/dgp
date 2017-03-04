class AddHiddenFieldToClient < ActiveRecord::Migration
  def change
    add_column :clients, :hidden, :boolean, default: false
  end
end

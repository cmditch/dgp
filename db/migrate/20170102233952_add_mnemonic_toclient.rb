class AddMnemonicToclient < ActiveRecord::Migration
  def change
    add_column :clients, :encrypted_mnemonic, :string
    add_column :clients, :encrypted_mnemonic_iv, :string
  end
end

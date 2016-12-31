class AddBitpayPemToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :encrypted_bitpay_pem, :string
    add_column :vendors, :encrypted_bitpay_pem_iv, :string
  end
end

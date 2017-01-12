class AddUsdSpotPriceToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :usd_spot_price, :float
  end
end

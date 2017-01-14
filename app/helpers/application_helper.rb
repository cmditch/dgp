module ApplicationHelper
  require 'dgp_module'
  def format_time(datetime)
    datetime.strftime("%-m/%-d/%y %H:%M %Z")
  end

  def to_usd(btc)
    ( (btc.to_f / (10 ** 8)) * DGP::MarketData.usd_btc_spot_price ).round(2)
  end
  
  def price_round(price)
    sprintf('%.2f', price)
  end

  def short(text)
    "#{text[0..3]}...#{text[-4..-1]}"
  end

  def tx_link(txid)
    "https://blockchain.info/tx/#{txid}"
  end

  def address_link(address)
    "https://blockchain.info/address/#{address}"
  end

end

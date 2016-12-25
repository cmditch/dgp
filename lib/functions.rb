module Functions
  module CurrencyConversion
    @to_eth = proc { |x| x.to_f / 10**16 }
    @to_btc = proc { |x| x.to_f / 10**8 }
  end
end
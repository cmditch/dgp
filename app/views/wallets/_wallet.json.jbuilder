json.extract! wallet, :id, :address, :balance, :created_at, :updated_at
json.url wallet_url(wallet, format: :json)
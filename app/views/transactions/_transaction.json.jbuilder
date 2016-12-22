json.extract! transaction, :id, :txid, :sender, :recipient, :amount, :time, :block_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
json.extract! bitpay_webhook, :id, :data, :created_at, :updated_at
json.url bitpay_webhook_url(bitpay_webhook, format: :json)
module CoinCap

  class Api

    def coin_details(coin = "BTC")
      api_http_get('/front').select { |coin| coin[:short] == coin.upcase }
    end

    def coin_price(coin = "BTC")
      info = coin_details(coin).first
      [info[:short], info[:price]]
    end

  private

    def api_http_call(http_method, api_path, query, json_payload: nil)
      uri = endpoint_uri(api_path, query)

      # Build the connection
      http    = Net::HTTP.new(uri.host, uri.port)
      # http.use_ssl = true

      # Build the Request
      if http_method == :post
        request = Net::HTTP::Post.new(uri.request_uri)
      elsif http_method == :get
        request = Net::HTTP::Get.new(uri.request_uri)
      elsif http_method == :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        raise 'Invalid HTTP method'
      end

      unless json_payload.nil?
        request.content_type = 'application/json'
        request.body = json_payload.to_json
      end

      response = http.request(request)

      # Detect errors/return 204 empty body
      if response.code == '400'
        raise Error.new(uri.to_s + ' Response:' + response.body)
      elsif response.code == '204'
        return nil
      end

      # Process the response
      begin
        json_response = JSON.parse(response.body)
        return json_response
      rescue => e
        raise "Unable to parse JSON response #{e.inspect}, #{response.body}"
      end
    end

    def api_http_get(api_path, query: {})
      api_http_call(:get, api_path, query)
    end

    def api_http_post(api_path, json_payload: nil, query: {})
      api_http_call(:post, api_path, query, json_payload: json_payload)
    end

    def api_http_delete(api_path, query: {})
      api_http_call(:delete, api_path, query)
    end

    def endpoint_uri(api_path, query)
      uri = URI("http://www.coincap.io/#{api_path}")
      uri.query = URI.encode_www_form(query) unless query.empty?
      uri
    end
  end
end
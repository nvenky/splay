module ApiNg
  class ServiceBase
    attr_accessor :params, :response

    class << self
      attr_accessor :logger

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end

    def initialize(exchange, params={})
      @exchange = exchange
      @params = params
    end

    def init_http
      @uri = URI.parse(uri)
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl=true
      http
    end

    def http
      @http ||= init_http
    end

    def default_params
      {}
    end

    def params
      default_params.merge(@params)
    end

    def headers
      {
          'X-Application' => app_key,
          'Accept' => 'application/json',
          'Content-type' => 'application/json',
          'X-Authentication' => sso_id
      }
    end

    def app_key
     '5k4smWlICCN3xe9e'
    end

    def sso_id
       @sso_id ||= ApiNg::Session.new.sso_id
    end

    def rpc_request
      {'jsonrpc' => '2.0', 'method' => "#{method_name_prefix}#{method_name}", 'params' => params, 'id' => 1}
    end

    def uri
      self.send("#{@exchange}_uri")
    end

    def uk_uri
      'https://api.betfair.com/exchange/betting/json-rpc/v1/'
    end

    def aus_uri
      'https://api-au.betfair.com/exchange/betting/json-rpc/v1/'
    end

    def method_name_prefix
      'SportsAPING/v1.0/'
    end

    def call
      ServiceBase.logger.debug "Invoking API NG @ #{uri} MethodName: #{method_name_prefix}#{method_name}"
      ServiceBase.logger.debug "Headers: #{headers}"
      ServiceBase.logger.debug "Request: #{rpc_request.to_json}"
      response = http.post(@uri.path, rpc_request.to_json, headers)
      ServiceBase.logger.debug "Response Body -  #{response.body}"
      hash = Hashie::Rash.new(JSON.parse(response.body, symbolize_names: true))
      verify_and_raise_error(hash)
      hash[:result]
    end

    def verify_and_raise_error(response)
      raise "#{response.error.code}: #{response.error.data}" unless response.error.nil?
    end
  end
end

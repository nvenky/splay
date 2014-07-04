module ApiNg
  class JsonRpc
    attr_accessor :params, :response

    class << self
      attr_accessor :logger

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end

    def initialize(exchange=:aus, params={})
      @exchange = (exchange == :uk) ? :uk : :aus #fall back on anything other than :uk
      self.params = params
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

    def fixed_params
      {}
    end


    # default params are overridden by user supplied
    # fixed_params override both to allow for convenient calling of highly specialized rpc
    def params
      default_params.merge(@params).merge(fixed_params)
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

    def aus_uri
      raise NotImplementedError, "Subclasses of #{self.class.to_s} must include ApiNg::SportsURI or ApiNg::AccountURI"
    end

    def method_name_prefix
      raise NotImplementedError, "Subclasses of #{self.class.to_s} must include ApiNg::SportsURI or ApiNg::AccountURI"
    end

    def method_name
      raise NotImplementedError, "Subclasses of #{self.class.to_s} must override #method_name"
    end

    def call
      JsonRpc.logger.debug "Invoking API NG @ #{uri} MethodName: #{method_name_prefix}#{method_name}"
      JsonRpc.logger.debug "Headers: #{headers}"
      JsonRpc.logger.debug "Request: #{rpc_request.to_json}"
      response = http.post(@uri.path, rpc_request.to_json, headers)
      JsonRpc.logger.debug "Response Body -  #{response.body}"
      Hashie::Rash.new(JSON.parse(response.body, symbolize_names: true))[:result]
    end
  end
end

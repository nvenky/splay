require "net/http"
require "uri"

module ApiNg
  class Session

    def init_http
      @uri = URI.parse('https://identitysso.betfair.com/api/login')
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl=true
      http
    end

    def http
      @http ||= init_http
    end

    def headers
      {
        'X-Application' => '5k4smWlICCN3xe9e',
        'Accept' => 'application/json',
        'Content-type' => 'application/x-www-form-urlencoded'
      }
    end

    def sso_id
      response = http.post(@uri.path, "username=#{ENV['USERNAME']}&password=#{ENV['PASS']}", headers)
      data = JSON.parse(response.body, symbolize_names: true)
      raise "Login failed - #{data[:error]}" if data[:status] != 'SUCCESS'
      data[:token]
    end
  end
end

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

    def pass
      crypt = ActiveSupport::MessageEncryptor.new('4fc392a6-7518-4160-b0ff-f48fa4527a33')
      crypt.decrypt_and_verify("eTJ6U1hieGVOMjNBVGYvdGZOcHRXdkZvbkVMUzV5QXJ1TkpPMnN1bVVKOD0tLUN5ODZCL2l3cU5NU2N1bmNRUG5vNXc9PQ==--e4ea6bea331358b6db12ff986082c1031fa1c293")
    end


    def sso_id
      response = http.post(@uri.path, "username=nvenky&password=#{pass}", headers)
      data = JSON.parse(response.body, symbolize_names: true)
      raise "Login failed - #{data[:error]}" if data[:status] != 'SUCCESS'
      data[:token]
    end
  end
end

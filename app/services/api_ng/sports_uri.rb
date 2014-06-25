module ApiNg
  module SportsURI
    def uk_uri
      'https://api.betfair.com/exchange/betting/json-rpc/v1/'
    end

    def aus_uri
      'https://api-au.betfair.com/exchange/betting/json-rpc/v1/'
    end

    def method_name_prefix
      'SportsAPING/v1.0/'
    end
  end
end

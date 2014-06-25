module ApiNg
  class Session
    def self.sso_id
      # use betfair api client gem for now but TODO remove dependency
      Thread.current[:session_token] or master_sso_id
    end

    def self.session_timeout
      (ENV['MASTER_SESSION_TIMEOUT'] || 5).to_i
    end

    def self.master_sso_id
      BetFair.cache.fetch('betfair_master_session_token', :expires_in => session_timeout.minutes) do
        # use betfair api client gem for now but TODO remove dependency
        request = BetFair::Adapters::Global::MasterLogin.new ::BetFair::VendorData.login_details
        request.session[:session_token]
      end
    end
  end
end

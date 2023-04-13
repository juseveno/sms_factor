# frozen_string_literal: true

class SmsFactor
  class Configuration
    # The SMS Factor API URL which should be https://api.smsfactor.com
    attr_accessor :api_url

    #
    # Authentications
    #
    # This gem supports 2 authentication methods. The "Email / password"
    # authentication method is the historical one and kept for compaitiblity
    # reason but you should go with the second method which is the "API key"
    # one, allowing you to update your SMS Factor account without breaking the
    # authentication against the API.
    #
    # 1. Email / password authentication (legacy)
    attr_accessor :api_login, :api_password
    # 2. API key authentication (recommanded)
    attr_accessor :api_key

    # The default name shown as the sender when none is passed to the
    # SmsFactor.sms method
    attr_accessor :api_default_from

    def initialize
      @api_url = 'https://api.smsfactor.com'
    end

    def api_auth?
      api_key.to_s.strip.empty? == false
    end

    def invalid?
      return true if minimal_config_invalid?

      return true if authentication_config_invalid?

      false
    end

    private

    def authentication_config_invalid?
      # The config is valid as soon as an API key is present
      return false unless api_key.nil?

      api_login.nil? || api_password.nil?
    end

    def minimal_config_invalid?
      api_url.nil? || api_default_from.nil?
    end
  end
end

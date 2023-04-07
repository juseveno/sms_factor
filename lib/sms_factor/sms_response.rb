# frozen_string_literal: true

class SmsFactor
  class SmsResponse
    attr_accessor :response

    def initialize(response)
      @response = JSON.parse(response)
    end

    def success?
      @response['status'] == 1
    end

    def message
      @response['message']
    end

    def method_missing(method_name, *args, &block)
      super unless @response.keys.include?(method_name.to_s)

      @response[method_name.to_s]
    end

    # https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
    def respond_to_missing?(method_name, include_private = false)
      @response.keys.include?(method_name.to_s) || super
    end
  end
end

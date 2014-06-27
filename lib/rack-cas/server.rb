require 'rack-cas/url'
require 'rack-cas/service_validation_response'

module RackCAS
  class Server
    def initialize(url)
      @url = RackCAS::URL.parse(url)
    end

    def login_url(service_url, params = {})
      service_url = URL.parse(service_url).to_s
      @url.dup.append_path('login').add_params({cassvc: 'ANY', casurl: service_url}.merge(params))
    end

    def logout_url(params = {})
      @url.dup.tap do |url|
        url.append_path('logout')
        url.add_params(params) unless params.empty?
      end
    end

    def validate_service(service_url, ticket)
      response = ServiceValidationResponse.new validate_service_url(service_url, ticket)
      [response.user]
    end

    protected

    def validate_service_url(service_url, ticket)
      service_url = URL.parse(service_url).remove_param('casticket').to_s
      @url.dup.append_path('validate').add_params(cassvc: 'ANY', casurl: service_url, casticket: ticket)
    end
  end
end
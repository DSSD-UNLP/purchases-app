class BonitaManager
  require 'uri'
  require 'net/http'

  BONITA_USERNAME = 'walter.bates'.freeze
  BONITA_PASSWORD = 'bpm'.freeze
  BONITA_HOST_URL = ENV['BONITA_HOST_URL']

  attr_reader :connection

  def initialize
    @connection = Faraday.new(url: BONITA_HOST_URL) do |conn|
      conn.response :logger
      conn.adapter Faraday.default_adapter
    end

    @cookies = Rails.cache.fetch("#{BONITA_HOST_URL}/cookies") do
      initialize_cookies(HTTP::CookieJar.new)
    end
    @cookies = initialize_cookies(HTTP::CookieJar.new) if @cookies.any?(&:expired?)
  end

  def start_case(body_params)
    response = connection.post('/bonita/API/bpm/case') do |request|
      request.headers['X-Bonita-API-Token'] = bonita_token
      request.headers['Content-Type']       = 'application/json'
      request.headers['Cookie']             = parsed_cookies
      request.headers['cache-control']      = 'no-cache'
      request.body = body_params.to_json
    end

    JSON.parse(response.body).symbolize_keys[:rootCaseId]
  end

  private

  def login_service
    connection.post do |request|
      request.url('/bonita/loginservice')
      request.params['username'] = BONITA_USERNAME
      request.params['password'] = BONITA_PASSWORD
      request.params['redirect'] = false
    end
  end

  def initialize_cookies(jar)
    @response_cookies = login_service.headers.to_hash['set-cookie']

    @response_cookies.split(',').each do |value|
      jar.parse(value, BONITA_HOST_URL)
    end

    jar.cookies(BONITA_HOST_URL)
  end

  def bonita_token
    @cookies.find do |cookie|
      cookie.name.underscore.to_sym == :x_bonita_api_token
    end.value
  end

  def parsed_cookies
    HTTP::Cookie.cookie_value(@cookies)
  end
end

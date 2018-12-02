class BonitaManager
  require 'uri'
  require 'net/http'
  BONITA_USERNAME = 'walter.bates'.freeze
  BONITA_PASSWORD = 'bpm'.freeze

  START_CASE_PARAMETERS = {
    'processDefinitionId': '4751000970449300331',
    'variables': [
      {
        'name': 'nombrecupon',
        'value': 'VERANISIMO'
      },
      {
        'name': 'email',
        'value': 'nachogarciaaaa@gmail.com'
      }
    ]
  }.freeze

  attr_reader :connection, :bonita_token

  def initialize
    # session[:bonita_manager] = self
    @connection = Faraday.new(url: ENV['BONITA_HOST_URL']) do |conn|
      conn.response :logger
      conn.adapter Faraday.default_adapter
    end
    set_bonita_token
    start_case
  end

  private

  def set_bonita_token
    response = connection.post do |request|
      request.url('/bonita/loginservice')
      request.params['username'] = BONITA_USERNAME
      request.params['password'] = BONITA_PASSWORD
      request.params['redirect'] = false
    end

    @bonita_token = parse_bonita_token(response.headers.to_hash)
  end

  def parse_bonita_token(headers)
    @cookies      = headers['set-cookie']
    bonita_token  = @cookies.split(',').find do |elem|
      elem.downcase.include? 'bonita-api-token'
    end

    jsession = @cookies.split(',').find do |elem|
      elem.downcase.include? 'jsession'
    end

    @jsession = jsession.split(';').first.strip.split('=').second
    bonita_token.split(';').first.strip.split('=').second
  end

  def start_case
    response = connection.post('/bonita/API/bpm/case') do |request|
      request.headers['X-Bonita-API-Token'] = @bonita_token
      request.headers['Content-Type']       = 'application/json'
      request.headers['Cookie']             = get_cookies
      request.headers['cache-control']      = 'no-cache'
      request.body = START_CASE_PARAMETERS.to_json
    end
    binding.pry
  end

  def get_cookies
    'bonita.tenant=1; path=/bonita; domain=localhost;' \
    "X-Bonita-API-Token=#{@bonita_token}; path=/; domain=localhost;" \
    "JSESSIONID=#{@jsession}; path=/; domain=localhost; HttpOnly;"
  end
end

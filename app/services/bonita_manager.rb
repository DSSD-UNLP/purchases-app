class BonitaManager
  require 'uri'
  require 'net/http'

  BONITA_USERNAME = 'walter.bates'.freeze
  BONITA_PASSWORD = 'bpm'.freeze
  BONITA_HOST_URL = ENV['BONITA_HOST_URL']
  PROCESS_DEFINITION_ID = ENV['PROCESS_DEFINITION_ID']
  CONFIRMATION_HASH = {
    type: 'java.lang.Boolean',
    value: 'true'
  }.freeze
  RESUME_PROCESS_BODY = {
    'processDefinitionId': PROCESS_DEFINITION_ID,
    'assigned_id': '4',
    'state': 'completed'
  }.freeze

  attr_reader :connection, :case_id

  def initialize(case_id: nil)
    @connection = Faraday.new(url: BONITA_HOST_URL) do |conn|
      conn.response :logger
      conn.adapter Faraday.default_adapter
    end

    @cookies = Rails.cache.fetch("#{BONITA_HOST_URL}/cookies") do
      initialize_cookies(HTTP::CookieJar.new)
    end
    @cookies = initialize_cookies(HTTP::CookieJar.new) if @cookies.any?(&:expired?)

    @case_id = case_id
  end

  def start_case(body_params)
    response = connection.post('/bonita/API/bpm/case') do |request|
      request.headers['X-Bonita-API-Token'] = bonita_token
      request.headers['Content-Type']       = 'application/json'
      request.headers['Cookie']             = parsed_cookies
      request.headers['cache-control']      = 'no-cache'
      request.body = body_params.to_json
    end
    @case_id = JSON.parse(response.body).symbolize_keys[:rootCaseId]
    Rails.cache.write("#{BONITA_HOST_URL}/last_case", @case_id, expires_in: 12.hours)

    @case_id
  end

  def value(variable)
    response = JSON.parse(
      ask_for_value(variable).body
    ).symbolize_keys

    while response[:value].blank?
      response = JSON.parse(
        ask_for_value(variable).body
      ).symbolize_keys
    end

    response[:value]
  end

  def finish_case_successfully
    task_id = task_id_for_case
    confirm_purchase
    resume_task(task_id)
  end

  private

  def resume_task(task_id)
    connection.put("/bonita/API/bpm/userTask/#{task_id}") do |request|
      request.headers['X-Bonita-API-Token'] = bonita_token
      request.headers['Cookie']             = parsed_cookies
      request.body = RESUME_PROCESS_BODY.to_json
    end
  end

  def confirm_purchase
    connection.get("/bonita/API/bpm/caseVariable/#{@case_id}/confirmacion") do |request|
      request.headers['X-Bonita-API-Token'] = bonita_token
      request.headers['Cookie']             = parsed_cookies
      request.body = CONFIRMATION_HASH.to_json
    end
  end

  def tasks
    connection.get do |request|
      request.url('/bonita/API/bpm/task')
      request.headers['X-Bonita-API-Token'] = bonita_token
      request.headers['Cookie']             = parsed_cookies
      request.params['p'] = 0
      request.params['c'] = 100
      request.params['o'] = 'state'
      request.params['f'] = "processId=#{PROCESS_DEFINITION_ID}"
    end
  end

  def task_id_for_case
    response = JSON.parse(tasks.body)
    response.find { |task| task.symbolize_keys[:caseId] == @case_id }.dig('id')
  end

  def ask_for_value(variable)
    connection.get("/bonita/API/bpm/caseVariable/#{@case_id}/#{variable}") do |request|
      request.headers['X-Bonita-API-Token'] = bonita_token
      request.headers['Cookie']             = parsed_cookies
    end
  end

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

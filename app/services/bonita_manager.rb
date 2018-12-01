class BonitaManager
  BONITA_USERNAME = 'walter.bates'.freeze
  BONITA_PASSWORD = 'bpm'.freeze

  START_CASE_PARAMETERS = {
    'processDefinitionId': '5024802776831045943',
    'variables': [
      {
        'name': 'nombrecupon',
        'value': 'VERANISIMO'
      },
      {
        'name': 'email',
        'value': 'nachogarciaaaa@gmail.com'
      },
      {
        'name': 'login',
        'value': 'true'
      }
    ]
  }.freeze

  def initialize
    @connection = Faraday.new(url: 'http://localhost:8080')
  end

  private

  def bonita_login
    @connection.post do |request|
      request.url('/loginservice')
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      request.body = {
        username: BONITA_USERNAME,
        password: BONITA_PASSWORD,
        recirect: false
      }.to_json
    end
  end

  def start_case
    @connection.post('API/bpm/case')
  end
end

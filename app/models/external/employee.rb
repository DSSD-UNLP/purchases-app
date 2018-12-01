class External::Employee < Flexirest::Base
  base_url ENV['EMPLOYEES_API_URL']

  get :find, '/rrhh/employee/login/:id/'
end

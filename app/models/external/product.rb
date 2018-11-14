class External::Product < Flexirest::Base
  base_url ENV['STOCK_API_URL']

  get :all, '/stock/products/'
  get :find, '/stock/products/:id'
end

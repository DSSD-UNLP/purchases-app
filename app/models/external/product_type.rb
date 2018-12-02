class External::ProductType < Flexirest::Base
  base_url ENV['STOCK_API_URL']

  get :all, '/stock/types/'
  get :find, '/stock/type/:id/'
end

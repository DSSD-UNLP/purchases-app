Rails.application.routes.draw do
  devise_for :users

  get :cart, controller: 'application'

  root to: 'products#index'

  resources :products, only: :index
end

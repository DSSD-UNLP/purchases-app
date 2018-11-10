Rails.application.routes.draw do
  devise_for :users

  get :cart, controller: 'application'

  resources :products, only: :index
end

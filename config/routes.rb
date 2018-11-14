Rails.application.routes.draw do
  root to: 'products#index'

  devise_for :users

  get :cart, controller: 'application'

  resources :products, only: :index do
    resources :coupons, only: :new
    post :coupon, to: 'coupons#validate', param: :name
  end
end

Rails.application.routes.draw do
  root 'packages#index'

  namespace :payment do
    get 'success', to: 'success#index'
    get 'cancel', to: 'cancel#index'
  end

  resources :orders, only: [:index, :create]
  resources :packages, only: [:index]
end

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  resources :product_colors
  resources :colors
  resources :orders
  resources :products
  resources :categories
  resources :users
  resources :provinces
  resources :order_items
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "home#index"
end

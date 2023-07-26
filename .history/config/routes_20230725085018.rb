Rails.application.routes.draw do
  
  # get 'home/index'
  
  devise_for :users
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }
  
  devise_for :admin_users, ActiveAdmin::Devise.config

  mount Ckeditor::Engine => '/ckeditor'
  resources :product_colors
  resources :colors
  resources :orders
  resources :products
  resources :categories
  resources :users
  resources :provinces
  resources :order_items

  resources :cart_items, only: [:index, :create, :update, :destroy]
  get 'cart', to: 'cart_items#index'

 

  root to: 'pages#front'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about', as: 'about'
  # Show product from a category
  get '/categories/:id/products', to: 'categories#show_products', as: 'category_products'
  

  # Admin login
  # get '/admin/login', to: 'admin/sessions#new', as: :admin_login

  resources :products, only: [:index, :show]

  resources :categories, only: [:show] do
    get 'products', on: :member, to: 'categories#show_products'
  end

  ActiveAdmin.routes(self)

end

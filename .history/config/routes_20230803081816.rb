Rails.application.routes.draw do
   
  devise_for :users  
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

  resources :cart_items, only: [:index, :create, :destroy, :update]
  get 'cart', to: 'cart_items#index'
  get 'cart_items/checkout', to: 'cart_items#checkout', as: 'checkout_cart'
  get '/calculate_taxes', to: 'cart_items#calculate_taxes', as: 'calculate_taxes'
  get '/cart/checkout', to: 'cart_items#checkout', as: 'cart_items_checkout'

  post 'create_order', to: 'orders#create', as: 'create_order'
  # post '/calculate_taxes', to: 'cart_items#calculate_taxes', as: :calculate_taxes
  
  # post '/checkout', to: 'cart_items#checkout', as: :checkout_cart_items
  # get '/cart/checkout', to: 'cart_items#checkout', as: :checkout_cart
  get '/cart/checkout', to: 'cart_items#checkout', as: 'cart_items_checkout'


  delete 'remove_from_cart', to: 'cart_items#remove_from_cart', as: :remove_from_cart
  

 

  root to: 'pages#front'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about', as: 'about'
  # Show product from a category
  get '/categories/:id/products', to: 'categories#show_products', as: 'category_products'

  # post '/checkout', to: 'orders#create', as: :checkout

  # get "/calculate_taxes", to: "orders#calculate_taxes"

  resources :orders, only: [:index, :show]

  # Admin login
  # get '/admin/login', to: 'admin/sessions#new', as: :admin_login

  resources :products, only: [:index, :show]

  resources :categories, only: [:show] do
    get 'products', on: :member, to: 'categories#show_products'
  end

  


  ActiveAdmin.routes(self)

end

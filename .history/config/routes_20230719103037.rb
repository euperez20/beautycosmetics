Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  get 'home/index'
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
  # root to: "home#index"
  root to: 'pages#front'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about', as: 'about'
  # Show product from a category
  # get '/categories/:id/products', to: 'categories#show_products', as: 'category_products'

  resources :categories, only: [:show] do
    get 'products', on: :member, to: 'categories#show_products'
  end
end

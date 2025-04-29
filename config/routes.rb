Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Health check route for monitoring services
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path for the application (Admin dashboard)
  root "admin/dashboard#index"

  # POS routes for adding to cart and checkout
  post "add_to_cart/:product_id", to: "pos#add_to_cart", as: :add_to_cart
  post "checkout", to: "pos#checkout", as: :checkout

  # User authentication routes for login/logout
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # User profile editing and password reset
  resources :users, only: [:edit, :update]
  get "/edit_password", to: "users#edit_password", as: :edit_password
  patch "/update_password", to: "users#update_password"

  # Admin routes within the namespace
  namespace :admin do
     get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    root to: 'dashboard#index'

    # Admin product management
    resources :products

    # Admin user management
    resources :users

    # Admin order management
    resources :orders, only: [:index, :show]

    # Admin profile management (assuming an Admin can edit their profile)
    get 'edit_profile', to: 'users#edit_profile', as: :edit_profile
    patch 'update_profile', to: 'users#update_profile', as: :update_profile
  end
end

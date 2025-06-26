Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication (using Devise)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  # Custom session routes (if keeping non-Devise endpoints)
  get "login", to: redirect("/users/sign_in") # Consider removing if using pure Devise
  delete "logout", to: "users/sessions#destroy" # Ensure this matches Devise's route

  # User routes
  resource :profile, only: [:edit, :update], controller: 'users' do
    get 'edit_password', on: :collection
    patch 'update_password', on: :collection
  end

  # POS routes
  scope module: :pos do
    post "add_to_cart/:product_id", to: "cart#add", as: :add_to_cart
    post "checkout", to: "checkout#process", as: :checkout
  end

  # Admin namespace
  namespace :admin do
    root to: 'dashboard#index'
    get 'dashboard', to: 'dashboard#index' # Consider removing if same as root

    resources :products
    resources :users
    resources :orders, only: [:index, :show]

    resource :profile, only: [] do
      get 'edit'
      patch 'update'
    end
  end

  # Root path - consider making this public facing
  root to: "admin/dashboard#index" # Might want to change to public page
end

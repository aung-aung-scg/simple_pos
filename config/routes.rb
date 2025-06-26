Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise Authentication
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  # Remove custom login/logout redirects — Devise handles it
  # (Optional) You can keep this if you want a friendly /login URL
  get "login", to: redirect("/users/sign_in")
  # delete "logout" line removed — use Devise's `destroy_user_session_path` instead

  # User profile management
  resource :profile, only: [:edit, :update], controller: 'users' do
    get 'edit_password'
    patch 'update_password'
  end

  # POS module routes (no path prefix, but controller under POS module)
  post "add_to_cart/:product_id", to: "pos#add_to_cart", as: :add_to_cart
  post "checkout", to: "pos#checkout", as: :checkout
  get 'cart', to: 'pos#show', as: :pos_cart
  get "pos", to: "pos#index", as: :pos

  # Admin namespace
  namespace :admin do
    root to: 'dashboard#index'

    resources :products
    resources :users
    resources :orders, only: [:index, :show]

    resource :profile, only: [] do
      get 'edit'
      patch 'update'
    end
  end

  # Redirect users after login to the correct dashboard (optional if handled in `after_sign_in_path_for`)
  authenticated :user do
    root to: 'admin/dashboard#index', as: :authenticated_root
  end

  # Default root path (unauthenticated users)
  root to: redirect('/users/sign_in')
end

Rails.application.routes.draw do
  # ✅ Pages
  root "pages#home"
  get "search/index"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"

  # ✅ Devise Authentication
  devise_for :customers, controllers: {
    sessions: "customers/sessions",
    registrations: "customers/registrations"
  }

  devise_for :business_admins, controllers: {
    sessions: "business_admins/sessions",
    registrations: "business_admins/registrations"
  }

  devise_for :store_managers, controllers: {
    sessions: "store_managers/sessions"
  }, skip: [:registrations]

  devise_for :super_admins, controllers: {
    sessions: "super_admins/sessions",
    registrations: "super_admins/registrations"
  }

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # ✅ Customers Area
  namespace :customers do
    get "reviews/index"
    get "reviews/destroy"
    resource :dashboard, only: [:show]
    resources :orders, only: [:index, :show, :create]
    resources :payments, only: [:index, :create]
    resources :receipts, only: [:show]
    resources :reviews, only: [:index, :destroy]


    get "order_history", to: "orders#history"
    get "saved_payments", to: "payments#saved"
    get "saved_receipts", to: "receipts#saved"
    resource :cart, only: [:show] do
      post "add_item", to: "carts#add_item"
      delete "remove_item", to: "carts#remove_item"
      patch "update_item", to: "carts#update_item"
      delete "clear_cart", to: "carts#clear_cart"
      post "checkout", to: "carts#checkout"
    end
  end

  # ✅ Business Admin Area
  namespace :business_admins do
    resources :stores do
      resource :dashboard, only: [:show], controller: "business_store_dashboard"
      resource :store_manager_credentials, only: [:edit, :update], controller: "business_store_manager_credentials"
    end
  end

  # ✅ Store Manager Area
  namespace :stores, only: [ :index, :show] do
    resource :store_dashboard, only: [:show]

    resources :orders do
      member do
        patch :approve
        patch :reject
      end
      collection do
        get :history
        get :live
      end
    end

    resources :products do
      collection do
        get :manage, action: :menu_management
      end
  end
  
    resources :payments, only: [:index]
    resources :receipts, only: [:index, :show, :new, :create]
    resources :customers, only: [:index, :show]

    get "dashboard", to: "store_dashboards#show"
    get "reports", to: "reports#index"
    get "settings", to: "settings#edit"
    patch "settings", to: "settings#update"
    delete "logout", to: "sessions#destroy"
    get "financial", to: "dashboard#financial"
  end

  # ✅ Super Admin Area
  resource :super_admin_dashboard, only: [:show]
  resources :users, only: [:index, :edit, :update, :destroy]
  resources :businesses, only: [:index, :destroy]
  resources :stores, only: [:index, :destroy]
  resources :orders, only: [:index, :destroy]
  resources :payments, only: [:index, :destroy]
  resources :reviews, only: [:create]

  # ✅ Global Search
  get "search", to: "search#index"

  # ✅ Health Check
  get "up", to: "rails/health#show", as: :rails_health_check
end
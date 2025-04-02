Rails.application.routes.draw do
  root "pages#home"

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

  # ✅ Customers
  namespace :customers do
    resource :dashboard, only: [:show]
    resources :orders, only: [:index, :show, :create]
    resources :payments, only: [:index, :create]
    get "cart", to: "carts#show"
    get "order_history", to: "orders#history"
    get "saved_payments", to: "payments#saved"
    get "receipts", to: "receipts#index"
  end

  # ✅ Business Admin Area
  namespace :business_admins do
    resources :stores do
      resource :dashboard, only: [:show], controller: "business_store_dashboard"
      resource :store_manager_credentials, only: [:edit, :update], controller: "business_store_manager_credentials"
    end
  end

  # ✅ Store Manager Area
  namespace :stores do
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

  # ✅ Super Admin
  resource :super_admin_dashboard, only: [:show]
  resources :users, only: [:index, :edit, :update, :destroy]
  resources :businesses, only: [:index, :destroy]
  resources :stores, only: [:index, :destroy]
  resources :orders, only: [:index, :destroy]
  resources :payments, only: [:index, :destroy]

  # ✅ General
  resources :carts, only: [:show, :update, :destroy]
  get "up", to: "rails/health#show", as: :rails_health_check
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
end
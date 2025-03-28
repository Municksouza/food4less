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

  # ✅ Customers Routes
  resource :customer_dashboard, only: [:show]
  resources :orders, only: [:index, :show, :create]
  resources :payments, only: [:index, :create]
  get "cart", to: "carts#show"
  get "order_history", to: "orders#history"
  get "saved_payments", to: "payments#saved"
  get "receipts", to: "receipts#index"

  # ✅ Business Admin Routes
  resource :business_dashboard, only: [:show]
  resources :businesses do
    resources :stores, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # ✅ Store Manager Routes
  resource :store_dashboard, only: [:show]
  resources :stores do
    resources :products
    resources :orders do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :payments, only: [:index]
    resources :customers, only: [:index, :show]
  end

  get "pending_orders", to: "orders#pending"
  get "store_payments", to: "payments#store_index"

  # ✅ Super Admin Routes
  resource :super_admin_dashboard, only: [:show]
  resources :users, only: [:index, :edit, :update, :destroy]
  resources :businesses, only: [:index, :destroy]
  resources :stores, only: [:index, :destroy]
  resources :orders, only: [:index, :destroy]
  resources :payments, only: [:index, :destroy]

  # ✅ General Routes
  resources :carts, only: [:show, :update, :destroy]
  get "up", to: "rails/health#show", as: :rails_health_check
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
end
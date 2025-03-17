Rails.application.routes.draw do
  root "pages#home"

  # Devise Authentication
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # Super Admin Dashboard (Full Access)
  authenticate :user, ->(u) { u.super_admin? } do
    resource :super_admin_dashboard, only: [:show]
    resources :users, only: [:index, :edit, :update, :destroy] # Manage Users
    resources :businesses, only: [:index, :destroy] # Manage Businesses
    resources :stores, only: [:index, :destroy] # Manage Stores
    resources :orders, only: [:index, :destroy] # Manage Orders
    resources :payments, only: [:index, :destroy] # Manage Payments
  end

  # Business Admin (Manage Businesses & Stores)
  authenticate :user, ->(u) { u.business_admin? } do
    resource :business_dashboard, only: [:show]
    resources :businesses do
      resources :stores, only: [:index, :new, :create, :edit, :update, :destroy]
    end
  end

  # Store Manager (Manage Stores, Products & Orders)
  authenticate :user, ->(u) { u.store_manager? } do
    resource :store_dashboard, only: [:show]
    resources :stores do
      resources :products
      resources :orders do
        member do
          patch :approve
          patch :reject
        end
      end
    end
  end

  # Customer (Manage Orders)
  authenticate :user, ->(u) { u.customer? } do
    resource :customer_dashboard, only: [:show]
    resources :orders, only: [:index, :show, :create]
  end

  # Payments (Refunds)
  resources :payments, only: [:index] do
    member do
      patch :refund
    end
  end

  # Health Check for Uptime Monitors
  get "up" => "rails/health#show", as: :rails_health_check
end
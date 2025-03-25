Rails.application.routes.draw do
  root "pages#home"

  # Devise Authentication
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  
  # Devise Authentication
  devise_for :business_admins, controllers: { sessions: "business_admins/sessions", registrations: "business_admins/registrations" }
  devise_for :customers, controllers: { sessions: "customers/sessions", registrations: "customers/registrations" }
  devise_for :store_managers, controllers: { sessions: "store_managers/sessions" }, skip: [:registrations]
  devise_for :super_admins, controllers: { sessions: "super_admins/sessions", registrations: "super_admins/registrations" }

  # Users - Perfil e Edição
  resources :users, only: [:index, :edit, :update, :destroy] do
    collection do
      get "edit_profile", to: "users#edit"
    end
  end

  # Super Admin Dashboard (Acesso Completo)
  authenticate :user, ->(u) { u.super_admin? } do
    resource :super_admin_dashboard, only: [:show]
    resources :users, only: [:index, :edit, :update, :destroy]
    resources :businesses, only: [:index, :destroy]
    resources :stores, only: [:index, :destroy]
    resources :orders, only: [:index, :destroy]
    resources :payments, only: [:index, :destroy]
  end

  # Business Admin (Gerencia Negócios e Lojas)
  authenticate :user, ->(u) { u.business_admin? } do
    resource :business_dashboard, only: [:show]
    resources :businesses do
      resources :stores, only: [:index, :new, :create, :edit, :update, :destroy]
    end
  end

  # Store Manager (Gerencia Loja, Produtos, Pedidos e Pagamentos)
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
      resources :payments, only: [:index] # Visualizar Pagamentos
      resources :customers, only: [:index, :show] # Perfil de Clientes
    end
    get "pending_orders", to: "orders#pending"
    get "store_payments", to: "payments#store_index"
  end

  # Customers (Pedidos, Carrinho e Perfil)
  authenticate :user, ->(u) { u.customer? } do
    resource :customer_dashboard, only: [:show]
    resources :orders, only: [:index, :show, :create]
    resources :payments, only: [:index, :create] # Métodos de Pagamento
    get "cart", to: "carts#show"
    get "order_history", to: "orders#history"
    get "saved_payments", to: "payments#saved"
    get "receipts", to: "receipts#index"
  end

  # Pagamentos (Reembolsos)
  resources :payments, only: [:index, :create] do
    member do
      patch :refund
    end
  end

  # Carrinho de Compras
  resources :carts, only: [:show, :update, :destroy]

  # Pedidos Pendentes
  get "pending_orders", to: "orders#pending"

  # Health Check
  get "up", to: "rails/health#show", as: :rails_health_check
end
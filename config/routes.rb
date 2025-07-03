Rails.application.routes.draw do
  

  # ✅ ActionCable mount
  mount ActionCable.server => '/cable'
  mount ActiveStorage::Engine => '/rails/active_storage'
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # ✅ Pages
  root to: "pages#home"
  get "search/index"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "products/show"

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
  }, skip: [:registrations], sign_out_via: [:delete, :get]

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # ✅ Customers Area
  namespace :customers do
    get "dashboard", to: "dashboards#show"

    resource :cart, only: [:show] do
      post :add_item
      patch :update_item
      delete :remove_item
      delete :clear_cart
      post :checkout
    end

    resources :orders, only: [:index, :show, :create]
    resources :payments, only: [:index, :create]
    resources :receipts, only: [:show]
    resources :reviews, only: [:index, :destroy]
    resources :refunds, only: [:index, :show]
    get "order_history", to: "orders#history"
    get "saved_payments", to: "payments#saved"
    get "saved_receipts", to: "receipts#saved"
  end

  # ✅ Business Admin Area
  namespace :business_admins do
    get "business_dashboard", to: "business_dashboard#show"
    get 'new_orders', to: 'orders#new_orders'

    resources :stores, param: :slug do
      # Rotas de Financial com escopo correto
      scope module: :stores do
        get 'financial', to: 'financial#index', as: :financial
        get 'financial/receipts', to: 'financial#receipts', as: :financial_receipts
        get 'financial/refunds', to: 'financial#refunds', as: :financial_refunds
        get 'financial/payments', to: 'financial#payments', as: :financial_payments
        get 'financial/reports', to: 'financial#reports', as: :financial_reports
        get 'financial/overview', to: 'financial#overview', as: :financial_overview
        get 'financial/monthly_report', to: 'financial#monthly_report', as: :financial_monthly_report
        get 'financial/yearly_report', to: 'financial#yearly_report', as: :financial_yearly_report
      end

      resources :sales, only: [:index, :show]

      resources :receipts, only: [:index, :show, :new, :create] do
        member do
          get :download
        end
      end
      resources :refunds, only: [:index, :show, :new, :create]
      resources :payments, only: [:index, :show, :new, :create]
      resources :reports, only: [:index, :show]

      member do
        get :dashboard, to: "business_store_dashboard#show"
        get :orders, to: "orders#index"
        patch :archive
        patch :restore
      end

      resources :orders do
        member do
          patch :approve
          patch :reject
          patch :finalize
          patch :set_ready_time
          patch :complete
          delete :delete
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
        member do
          patch :archive
          patch :restore
        end
      end

      resource :store_manager_credentials, only: [:edit, :update], controller: "business_store_manager_credentials"
    end

    get "settings", to: "settings#edit"
    patch "settings", to: "settings#update"
    delete "logout", to: "sessions#destroy"
    patch "orders/:id/complete", to: "orders#complete", as: :complete_stores_order
  end

  # ✅ Store Manager Area
  namespace :store_managers_area, path: 'stores', param: :slug do
    resources :stores, only: [:show, :edit, :update, :index] do
      member do
        get :dashboard, to: "store_dashboards#show"
        get :sales, to: "sales#index"
        get :financial, to: "dashboard#financial"
        get :reports, to: "reports#index"
        get :settings, to: "settings#edit"
        patch :settings, to: "settings#update"
        delete :logout, to: "sessions#destroy"
      end
    end

    get 'new_orders', to: 'orders#new_orders'

    resources :financials, only: [:index] do
      collection do
        get :refunds
        get :payments
        get :reports
      end
      resources :receipts, only: [:index, :show, :new, :create] do
        member do
          get :download
        end
      end
    end

    resources :orders do
      member do
        patch :approve
        patch :reject
        patch :finalize
        patch :set_ready_time
        patch :complete
        delete :delete
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
      member do
        patch :archive
        patch :restore
      end
    end

    resources :payments, only: [:index]
    resources :receipts, only: [:index, :show, :new, :create]
    resources :refunds

    resource :settings, only: [:edit, :update]
    resource :store_dashboard, only: [:show]
  end

  # ✅ Global Admin Resources
  resources :users, only: [:index, :edit, :update, :destroy]
  resources :orders, only: [:index, :destroy]
  resources :payments, only: [:index, :destroy, :create]
  resources :reviews, only: [:create]
  resources :products, only: [:index, :show]
  resources :stores, only: [:index, :edit, :update, :destroy, :show], param: :slug do
    get :search_products, on: :member
  end

  resources :testimonials, only: [:index] 
  
  # ✅ Global Search
  get "search", to: "search#index"

  # ✅ Health Check
  get "up", to: "rails/health#show", as: :rails_health_check

  # ✅ Public Customer Pages
  get 'products/category/:category_name', to: 'products#category', as: 'products_category'
  get "customers/:id", to: "shared/customers#show", as: "public_customer"
  get "customers", to: "shared/customers#index", as: "public_customers"

  match '*path', to: 'errors#not_found', via: :all, constraints: lambda { |req|
    !req.path.starts_with?('/rails/active_storage')
  } if Rails.env.production? 
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end

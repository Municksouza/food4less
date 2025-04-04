module Shared
  class CustomersController < ApplicationController
    before_action :authenticate_business_admin_or_store_manager!
  
    def index
      @customers = Customer.all
    
      query_param = params[:query] || params.dig(:search, :query)
    
      if query_param.present?
        q = "%#{query_param}%"
        @customers = @customers.where("name ILIKE :q OR email ILIKE :q OR phone ILIKE :q", q: q)
    
        if @customers.count == 1
          redirect_to customer_path(@customers.first) and return
        elsif @customers.empty?
          flash.now[:alert] = "Nenhum cliente encontrado com esse termo."
        end
      end
    end
    
    def show
      @customer = Customer.find(params[:id])
      @orders = @customer.orders.order(created_at: :desc).limit(20)
      @receipts = @customer.receipts.order(created_at: :desc).limit(20)
      @payments = @customer.payments.order(created_at: :desc).limit(20)
      @reviews = @customer.reviews.order(created_at: :desc).limit(20)    
    end
  
    private
  
    def authenticate_business_admin_or_store_manager!
      unless business_admin_signed_in? || store_manager_signed_in?
        redirect_to root_path, alert: "Acesso não autorizado."
      end
    end
  end
end
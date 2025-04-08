class ReportsController < ApplicationController
    before_action :authenticate_store_manager!
  
    def index
      @daily_sales = current_store_manager.store.orders.accepted.where('created_at >= ?', Time.zone.now.beginning_of_day).sum(:total_amount)
      @weekly_sales = current_store_manager.store.orders.accepted.where('created_at >= ?', Time.zone.now.beginning_of_week).sum(:total_amount)
      @monthly_sales = current_store_manager.store.orders.accepted.where('created_at >= ?', Time.zone.now.beginning_of_month).sum(:total_amount)
      @yearly_sales = current_store_manager.store.orders.accepted.where('created_at >= ?', Time.zone.now.beginning_of_year).sum(:total_amount)
    end
end
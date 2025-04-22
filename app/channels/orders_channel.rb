class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "store_#{params[:store_id]}_orders"
    Rails.logger.info "📡 Store #{params[:store_id]} connected to OrdersChannel"  
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

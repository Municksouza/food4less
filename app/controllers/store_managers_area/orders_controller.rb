module StoreManagersArea
  class OrdersController < ApplicationController
    before_action :authenticate_store_manager!
    before_action :set_store
    before_action :set_order, only: [:approve, :reject, :finalize, :destroy, :set_ready_time]

    def index
      @orders          = @store.orders.order(created_at: :desc)
      @accepted_orders = @orders.accepted
      @pending_orders  = @orders.pending
      @completed_orders = @orders.completed
    end
    
    def create
      @order = @store.orders.new(order_params)
      if @order.save
        payload = { order: @order.as_json }
        OrderBroadcaster.new(@order).broadcast_new
        redirect_to store_managers_area_store_dashboard_path, notice: "Order created successfully."
      else
        render :new, alert: "Failed to create order."
      end
    end

    def approve
      if params[:order].present? && params[:order][:ready_in_minutes].present? &&
        @order.update(
          status: :accepted,
          ready_in_minutes: params[:order][:ready_in_minutes],
          countdown_end_time: Time.current + params[:order][:ready_in_minutes].to_i.minutes
        )

        OrderBroadcaster.new(@order).broadcast_accept

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to store_managers_area_orders_path(slug: @order.store.slug), notice: 'Order approved successfully.' }
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "order-#{@order.id}",
              partial: "store_managers_area/orders/order",
              locals: { order: @order, play_sound: false }
            )
          end
          format.html do
            flash[:alert] = "Error approving the order: #{@order.errors.full_messages.to_sentence}"
            redirect_to store_managers_area_orders_path(slug: @order.store.slug)
          end
        end
      end
    end

    def reject
      if @order.update(status: 'rejected')
        OrderBroadcaster.new(@order).broadcast_reject
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to store_managers_area_orders_path(slug: @order.store.slug), notice: 'Order rejected successfully.' }
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("order-#{@order.id}", partial: "store_managers_area/orders/order", locals: { order: @order }) }
          format.html { redirect_to store_managers_area_orders_path(slug: @order.store.slug), alert: 'Error rejecting the order.' }
        end
      end
    end

    def finalize
      @order = Order.find(params[:id])
      if @order.update(status: "completed", finalized_at: Time.current)  # changed: using "completed"
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.remove("order-#{@order.id}") }
          format.html { redirect_to store_managers_area_orders_path(slug: @order.store.slug), notice: "Order finalized successfully." }
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("order-#{@order.id}", partial: "store_managers_area/orders/order", locals: { order: @order, play_sound: false }) }
          format.html { redirect_to store_managers_area_orders_path(slug: @order.store.slug), alert: "Failed to finalize order." }
        end
      end
    end

    def in_progress_orders
      @in_progress_orders = @store.orders.accepted.order(created_at: :desc)
    end

    def destroy
      @order.destroy
      redirect_to store_managers_area_store_dashboard_path, notice: "Order ##{@order.id} has been deleted."
    end

    def set_ready_time
      if @order.accepted?
        if params[:ready_in_minutes].present?
          @order.update!(estimated_ready_time: Time.current + params[:ready_in_minutes].to_i.minutes)
          redirect_to store_managers_area_store_dashboard_path, notice: "Ready time set."
        else
          redirect_to store_managers_area_store_dashboard_path, alert: "Ready time is required."
        end
      else
        redirect_to store_managers_area_store_dashboard_path, alert: "Order must be accepted first."
      end
    end

    def history
      @order_history = current_store_manager.store.orders.completed
    end

    def complete
      @order.update!(status: "completed")
      redirect_to store_managers_area_store_dashboard_path(order_id: @order.id), notice: "Order completed!"
    end

    def generate_invoice
      pdf = Prawn::Document.new
      pdf.text "Invoice - Order ##{@order.id}"
      send_data pdf.render, filename: "invoice_#{@order.id}.pdf", type: "application/pdf"
    end

    def new_orders
      new_orders = @store.orders.where(status: 'new').exists?
      render json: { new_orders: new_orders }
    end

    def show
      @order = @store.orders.find_by(id: params[:id])
      unless @order
        redirect_to store_managers_area_store_dashboard_path, alert: "Order not found." and return
      end

      @pending_orders = @store.orders.pending.order("COALESCE(countdown_end_time, updated_at) ASC")
      @accepted_orders = @store.orders.accepted.order("COALESCE(countdown_end_time, updated_at) ASC")      
      @completed_orders = @store.orders.completed.order("COALESCE(countdown_end_time, updated_at) ASC")
      @rejected_orders = @store.orders.rejected.order("COALESCE(countdown_end_time, updated_at) ASC")
    end

    private

    def authenticate_store_manager!
      redirect_to root_path, alert: "Access denied." unless store_manager_signed_in?
    end

    def set_store
      @store = current_store_manager.store
    end

    def set_order
      @order = @store.orders.find_by(id: params[:id])
      unless @order
        Rails.logger.error "Order not found for ID: #{params[:id]}"
        render json: { error: "Order not found" }, status: :not_found
      end
    end

    def order_params
      params.require(:order).permit(:status, :total_price, :customer_name, :customer_email, :ready_in_minutes, :countdown_end_time)
    end
  end
end

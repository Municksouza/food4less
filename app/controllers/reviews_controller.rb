class ReviewsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @reviews = current_customer.reviews.includes(:store, :order).order(created_at: :desc)
  end
  
  def create
    unless params[:review] && params[:review][:order_id]
      return redirect_to customers_dashboard_path, alert: "Order ID is missing."
    end

    order = Order.find_by(id: params[:review][:order_id])
    return redirect_to customers_dashboard_path, alert: "Order not found." unless order
    return redirect_to customers_dashboard_path, alert: "You already reviewed this order." if order.review
  
    review = Review.new(review_params)
    review.customer = current_customer
    review.store = order.store
    review.order = order
  
    if review.save
      redirect_to customers_dashboard_path, notice: "Thanks for your feedback!"
    else
      redirect_to customers_dashboard_path, alert: "Failed to submit review."
    end
  end

  def destroy
    review = Review.find(params[:id])
    if review.customer == current_customer
      review.destroy
      redirect_to customers_dashboard_path, notice: "Review deleted successfully."
    else
      redirect_to customers_dashboard_path, alert: "You cannot delete this review."
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
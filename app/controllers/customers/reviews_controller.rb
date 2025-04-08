class Customers::ReviewsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @reviews = current_customer.reviews.includes(:store, :order).order(created_at: :desc)
  end

  def destroy
    review = current_customer.reviews.find(params[:id])
    review.destroy
    redirect_to customers_reviews_path, notice: "Review deleted successfully."
  end
end
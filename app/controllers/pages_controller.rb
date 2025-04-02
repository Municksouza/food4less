class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]

  def home
    @products = Product.all.includes(:store).limit(20)
  end

  def about
    # Displays the "About Us" page
  end
  
  def contact
    # Displays the "Contact Us" page
  end
end

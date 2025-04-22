class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]

  def home
    @products = Product.includes(:store, images_attachments: :blob).order(created_at: :desc)
    @stores = Store.all
  end
  def about
    # Displays the "About Us" page
  end
  
  def contact
    # Displays the "Contact Us" page
  end
end

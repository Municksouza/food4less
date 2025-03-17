class PagesController < ApplicationController
  def home
    @products = Product.all.limit(10) 
  end
end

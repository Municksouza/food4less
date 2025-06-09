# app/controllers/testimonials_controller.rb
class TestimonialsController < ApplicationController
  def index
    @testimonials = Testimonial.visible
  end
end
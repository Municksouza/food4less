class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]

  def home
    @products = Product.includes(:store, images_attachments: :blob)
                       .where(active: true)
                       .order(created_at: :desc)
                       .limit(6)
    @stores = Store
                .where(latitude: 49.0..60.0, longitude: -110.0..-101.0)
                .where.not(latitude: nil, longitude: nil)

    @mini_carousel_items = [
      { image: "cuisine-burgers.webp", label: "Burgers",   category: "burgers" },
      { image: "cuisine-sushi.webp",   label: "Sushi",    category: "sushi"   },
      { image: "cuisine-pizza.webp",   label: "Pizza",    category: "pizza"   },
      { image: "cuisine-salad.webp",   label: "Salad",    category: "salad"   },
      { image: "cuisine-taco.webp",    label: "Tacos",    category: "tacos"   },
      { image: "cuisine-pasta.webp",   label: "Pasta",    category: "pasta"   },
      { image: "cuisine-shawarma.webp",label: "Shawarma", category: "shawarma" },
      { image: "cuisine-steahouse.webp",label: "Steakhouse", category: "steakhouse" },
      { image: "cuisine-korean.webp", label: "Korean", category: "korean" },
    ]
    
  end
  
  def about
    # Displays the "About Us" page
  end
  
  def contact
    # Displays the "Contact Us" page
  end
end

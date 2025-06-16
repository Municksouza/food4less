FactoryBot.define do
  factory :cart_item do
    quantity { 2 }
    cart
    product
  end
end

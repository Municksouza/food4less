FactoryBot.define do
  factory :order do
    total_price { 2000 }
    customer
    store
    status { "pending" }
  end
end

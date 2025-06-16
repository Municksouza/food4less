FactoryBot.define do
  factory :review do
    title    { "Great service" }
    comment  { "This is a sample review comment." }
    rating   { 5 }
    customer
    order
    store
    product
  end
end
FactoryBot.define do
  factory :customer do
    name { "Customer Test" }
    phone { "123-456-7890" }
    sequence(:email) { |n| "customer#{n}@example.com" }
    password { "Abc@1234" }
    password_confirmation { "Abc@1234" }
  end
end
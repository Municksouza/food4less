FactoryBot.define do
  factory :business_admin do
    name { "Admin Test" }
    email { Faker::Internet.email }
    password { "Abc@1234" }
    password_confirmation { "Abc@1234" }
    address { "123 Main Street" }
    zip_code { "S7H4Y7" }
    phone { "306-555-1234" }
    business_number { Faker::Number.unique.number(digits: 9).to_s }
    # logo não é obrigatório
  end
end
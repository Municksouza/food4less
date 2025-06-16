FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "Store #{n} #{Faker::Company.name}" }
    address { "123 Main St" }
    phone { "+1 306-123-4567" }
    zip_code { "S7H4Y7" }
    description { "Test" }
    status { "active" }
    email { Faker::Internet.email }
    association :business_admin
    association :category
    slug { nil } # Slug will be generated automatically
    cuisine
    business_number { Faker::Number.unique.number(digits: 9).to_s } 

    after(:build) do |store|
      file_path = Rails.root.join("test/fixtures/files/logo.png")
      store.logo.attach(
        io: File.open(file_path),
        filename: "logo.png",
        content_type: "image/png"
      )
    end
  end
end
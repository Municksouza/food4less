FactoryBot.define do
  factory :store_manager do
    email { Faker::Internet.email }
    password { "Test@1234" }
    receive_notifications { true }
    association :business_admin
    association :store

    after(:create) do |manager|
      create(:store, 
        name: "Test Store",
        address: "123 Main St",
        phone: "306-123-4567",
        zip_code: "S7H4Y7",
        email: Faker::Internet.email,
        business_number: "123456789",
        store_manager: manager
      ) unless manager.respond_to?(:store) && manager.store.present?
    end
  end
end
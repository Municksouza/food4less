FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Snacks#{n}" }
  end
end

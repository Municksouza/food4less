FactoryBot.define do
  factory :cuisine do
    sequence(:name) { |n| "Cuisine #{n}" }
  end
end
FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product_#{n}" }
    description { "Test description" }
    price { 10.0 }
    old_price { 15.0 }
    stock { 20 }
    association :store
    association :category

    after(:build) do |product|
      file_path = Rails.root.join("test/fixtures/files/logo.png")
      # Ensure the file is a raster image (PNG/JPEG), not SVG
      product.images.attach(
        io: File.open(file_path),
        filename: "logo.png",
        content_type: "image/png"
      )
    end
  end
end
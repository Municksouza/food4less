# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# frozen_string_literal: true

require 'faker'
require 'open-uri'

Review.destroy_all
Refund.destroy_all
Receipt.destroy_all
Payment.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
StoreManager.destroy_all
Store.destroy_all
BusinessAdmin.destroy_all
Customer.destroy_all

puts "✅ Data cleanup completed."

# Path to placeholder image (for BusinessAdmin only)
logo_path = Rails.root.join('app', 'assets', 'images', 'placeholder.jpeg')
unless File.exist?(logo_path)
  puts "⚠️ Logo file not found at #{logo_path}."
end

# Seed Categories
puts "🌱 Creating cuisine categories..."
cuisines = %w[Italian Chinese Indian Mexican Japanese French Brazilian Thai Greek Spanish]
cuisines.each do |name|
  Category.find_or_create_by!(name: name)
  puts "✅ Category created: #{name}"
end

# Create BusinessAdmin
admin = BusinessAdmin.new(
  name:                  "MarketGroup Inc.",
  email:                 "admin@marketgroup.com",
  phone:                 "306-555-9999",
  zip_code:              "S7K 0H2",
  address:               "Main Office - Saskatoon, SK",
  password:              "123456",
  password_confirmation: "123456"
)
if File.exist?(logo_path)
  admin.logo.attach(
    io:           File.open(logo_path),
    filename:     'placeholder.jpeg',
    content_type: 'image/jpeg'
  )
end
admin.save!
puts "✅ BusinessAdmin created: #{admin.email} | password: 123456"

# Prepare varied Saskatoon streets
saskatoon_streets = [
  "20th St W", "Broad St", "3rd Ave N", "8th St E",
  "Attridge Dr", "Circle Dr N", "College Dr", "Lorne Ave",
  "Idylwyld Dr N", "University Dr"
]

# Stores, StoreManagers, Products
stores_data = [
  "Westside Market", "Southside Grocers", "Eastside Foods",
  "Central Market", "Downtown Deli", "Northside Grocery",
  "Riverbend Market", "Hilltop Grocers"
]

stores_data.each do |store_name|
  # Build address
  address = "#{rand(100..999)} #{saskatoon_streets.sample}, Saskatoon, SK"

  # 1) Build in memory
  store = admin.stores.new(
    name:                  store_name,
    address:               address,
    zip_code:              "S7K 0H2",
    email:                 Faker::Internet.email,
    phone:                 Faker::PhoneNumber.cell_phone_in_e164,
    description:           Faker::Company.catch_phrase,
    status:                "active",
    receive_notifications: true
  )

  # Attach logo
  seed = store_name.parameterize
  logo_url = "https://picsum.photos/seed/#{seed}/200/200"
  store.logo.attach(
    io:           URI.open(logo_url),
    filename:     "logo-#{store.id}.jpg",
    content_type: 'image/jpeg'
  )

  # Save store
  store.save!
  store.geocode if store.respond_to?(:geocode)
  puts "✅ Store '#{store.name}' created at #{store.address}"

  # StoreManager
  manager = StoreManager.create!(
    email:                 "manager_#{store.id}@demo.com",
    password:              "123456",
    store:                 store,
    receive_notifications: true
  )
  puts "✅ StoreManager created: #{manager.email}"

  # 5 products with varied food photos
  5.times do
    old_price = Faker::Commerce.price(range: 20.0..100.0)
    discount  = rand(10..40)
    price     = (old_price * ((100 - discount) / 100.0)).round(2)

    product = store.products.create!(
      name:        Faker::Commerce.product_name,
      description: Faker::Food.description,
      old_price:   old_price,
      price:       price,
      stock:       rand(10..100),
      category:    Category.order(Arel.sql("RANDOM()")).first
    )

    # Attach product image
    seed     = "#{store.id}-#{product.id}"
    img_url  = "https://picsum.photos/seed/#{seed}/300/300"
    product.images.attach(
      io:           URI.open(img_url),
      filename:     "prod-#{product.id}.jpg",
      content_type: 'image/jpeg'
    )
    puts "  ✅ Product '#{product.name}' image attached"
  end
end

# Seed Customers with Faker avatars
puts "🌱 Creating customers..."
5.times do
  name     = Faker::Name.name
  email    = Faker::Internet.unique.email(domain: 'example.com')
  customer = Customer.create!(
    name:                  name,
    email:                 email,
    phone:                 Faker::PhoneNumber.cell_phone_in_e164,
    password:              "123456",
    password_confirmation: "123456"
  )
  avatar_url = Faker::Avatar.image(slug: name.parameterize, size: "100x100", format: "png")
  customer.photo.attach(
    io:           OpenURI.open_uri(avatar_url),
    filename:     "avatar-#{customer.id}.png",
    content_type: 'image/png'
  )
  puts "✅ Customer created: #{customer.email}"
end

puts "🌱 Creating orders, payments and receipts..."

Customer.find_each do |customer|
  2.times do
    store = Store.order(Arel.sql("RANDOM()")).first or next
    order = customer.orders.create!(store: store, total_price: 0.0, status: "pending")

    # Create some items
    3.times do
      product = store.products.order(Arel.sql("RANDOM()")).first or next
      qty     = rand(1..3)
      item    = order.order_items.create!(
        product:    product,
        quantity:   qty,
        unit_price: product.price,
        price:      product.price * qty
      )
      order.total_price += item.price
    end
    order.save!

    # Payment
    payment = Payment.create!(
      order:          order,
      store:          store,
      amount:         order.total_price,
      payment_method: %w[PayPal Stripe].sample,
      status:         'paid',
      transaction_id: SecureRandom.hex(10),
      payment_date:   Time.current
    )

    # Receipt
    receipt = Receipt.create!(
      order:        order,
      store:        store,
      amount:       order.total_price,
      content:      "Receipt for Order ##{order.id}",
      receipt_type: 'store'
    )

    # Send by email (and silence failures)
    [
      -> { ReceiptMailer.send_receipt_to_customer(receipt).deliver_now },
      -> { ReceiptMailer.send_receipt_to_store(receipt).deliver_now },
      -> { ReceiptMailer.send_receipt_to_business(receipt).deliver_now }
    ].each do |mail|
      begin
        mail.call
      rescue => e
        puts "⚠️ Email error: #{e.message}"
      end
    end

    puts "✅ Order ##{order.id} created for #{customer.email}"
  end
end

# Generate missing receipts and random refunds
puts "🌱 Generating additional receipts and refunds..."
Order.find_each do |order|
  unless Receipt.exists?(order_id: order.id)
    Receipt.create!(
      order:        order,
      store:        order.store,
      amount:       order.total_price,
      content:      "Generated Receipt for Order ##{order.id}",
      receipt_type: 'store',
      issued_at:    Time.current
    )
    puts "🧾 Generated receipt for Order ##{order.id}"
  end
  if [true, false].sample
    refund_amount = rand(1..(order.total_price * 0.5)).round(2)
    Refund.create!(
      order:       order,
      store:       order.store,
      amount:      refund_amount,
      reason:      %w[Product damaged Late delivery Customer complaint].sample,
      refund_date: Time.current
    )
    puts "💸 Refund issued for Order ##{order.id} - Amount: #{refund_amount}"
  end
end

# Seed Reviews for Products and Stores
puts "🌱 Seeding product reviews..."
Product.find_each do |product|
  rand(1..5).times do
    order = product.order_items.any? ? product.order_items.sample.order : Order.order(Arel.sql('RANDOM()')).first
    Review.create!(
      product:  product,
      store:    product.store,
      customer: Customer.order(Arel.sql('RANDOM()')).first,
      order:    order,
      comment:  Faker::Lorem.paragraph(sentence_count: 2),
      rating:   rand(1..5)
    )
  end
  puts "✅ Seeded #{product.reviews.count} reviews for product ##{product.id}"
end

puts "🌱 Seeding store-only reviews..."
Store.find_each do |store|
  rand(1..3).times do
    product  = store.products.order(Arel.sql('RANDOM()')).first
    customer = Customer.order(Arel.sql('RANDOM()')).first
    order    = if product && product.order_items.any?
                 product.order_items.sample.order
               else
                 Order.order(Arel.sql('RANDOM()')).first
               end

    # Only create if all exist
    next unless product && customer && order

    Review.create!(
      product:  product,
      store:    store,
      customer: customer,
      order:    order,
      comment:  Faker::Lorem.paragraph(sentence_count: 2),
      rating:   rand(1..5)
    )
  end

  puts "✅ Seeded #{store.reviews.where(store: store).count} generic reviews for store ##{store.id}"
end

puts "✅ db/seeds.rb run complete!"

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# frozen_string_literal: true

require 'faker'

# Data cleanup
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

# Path to placeholder image
logo_path = Rails.root.join('app', 'assets', 'images', 'placeholder.jpeg')

unless File.exist?(logo_path)
  puts "⚠️ Logo file not found at #{logo_path}. Please check the path and file existence."
end

puts "🌱 Creating cuisine categories..."

cuisines = [
  "Italian",
  "Chinese",
  "Indian",
  "Mexican",
  "Japanese",
  "French",
  "Brazilian",
  "Thai",
  "Greek",
  "Spanish"
]

cuisines.each do |cuisine_name|
  Category.find_or_create_by!(name: cuisine_name)
  puts "✅ Category created: #{cuisine_name}"
end

admin = BusinessAdmin.new(
  name: "MarketGroup Inc.",
  email: "admin@marketgroup.com",
  phone: "306-555-9999",
  zip_code: "S7K 0H2",
  address: "Main Office - Saskatoon, SK",
  password: "123456",
  password_confirmation: "123456"
)
if File.exist?(logo_path)
  admin.logo.attach(
    io: File.open(logo_path),
    filename: 'placeholder.jpeg',
    content_type: 'image/jpeg'
  )
else
  puts "⚠️ Admin logo attachment skipped as the file does not exist."
end

admin.save!
puts "✅ BusinessAdmin created: #{admin.email} | password: 123456"

stores_data = [
  # Sample store data
  { name: "Westside Market", address: "123 Main St, Saskatoon, SK", zip_code: "S7K 0H2" },
  { name: "Southside Grocers", address: "456 Elm St, Saskatoon, SK", zip_code: "S7K 0H2" },
  { name: "Eastside Foods", address: "789 Maple Ave, Saskatoon, SK", zip_code: "S7K 0H2" },
  { name: "Central Market", address: "321 Oak St, Saskatoon, SK", zip_code: "S7K 0H2" },
  { name: "Downtown Deli", address: "654 Pine St, Saskatoon, SK", zip_code: "S7K 0H2" },
  { name: "Northside Grocery", address: "987 Birch St, Saskatoon, SK", zip_code: "S7K 0H2" },
  { name: "Riverbend Market", address: "159 Cedar St, Saskatoon, SK", zip_code: "S7K 0H2" },
  { name: "Hilltop Grocers", address: "753 Spruce St, Saskatoon, SK", zip_code: "S7K 0H2" },
]

# Create stores
stores_data.each do |data|
  store = admin.stores.new(
    name: data[:name],
    address: data[:address],
    zip_code: data[:zip_code],
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    description: Faker::Company.catch_phrase,
    status: "active",
    receive_notifications: true
  )

  store.logo.attach(io: File.open(logo_path, "rb"), filename: 'placeholder.jpeg', content_type: 'image/jpeg')

  store.save!
  store.geocode if store.respond_to?(:geocode)
  puts "✅ Store '#{store.name}' created successfully."

  StoreManager.create!(email: "manager_#{store.id}@demo.com", password: "123456", store: store, receive_notifications: true)
  puts "✅ StoreManager created: manager_#{store.id}@demo.com"

  5.times do
    old_price = Faker::Commerce.price(range: 20.0..100.0)
    discount = rand(10..40) # desconto entre 10% e 40%
    price = (old_price * ((100 - discount) / 100.0)).round(2)
    
    product = store.products.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.sentence,
      old_price: old_price,
      price: price,
      stock: rand(10..100),
      category: Category.order("RANDOM()").first
    )
    if File.exist?(logo_path)
      product.images.attach(io: File.open(logo_path), filename: 'placeholder.jpeg', content_type: 'image/jpeg')
    else
      puts "⚠️ Product image skipped: file not found."
    end
    puts "✅ Product '#{product.name}' created for Store '#{store.name}'."
  end
end

# Create customers
5.times do
  email = Faker::Internet.unique.email
  customer = Customer.create!(
    name: Faker::Name.name,
    email: email,
    phone: Faker::PhoneNumber.phone_number,
    password: "123456",
    password_confirmation: "123456"
  )
  if File.exist?(logo_path)
    customer.photo.attach(io: File.open(logo_path), filename: 'placeholder.jpeg', content_type: 'image/jpeg')
  end
  puts "✅ Customer created: #{email} | password: 123456"
end

# Create orders, payments, receipts, and refunds
Customer.all.each do |customer|
  2.times do
    store = Store.order(Arel.sql("RANDOM()")).first || next
    order = customer.orders.create!(store: store, total_price: 0.0, status: "pending")

    3.times do
      product = store.products.order(Arel.sql("RANDOM()")).first || next
      quantity = rand(1..3)
      item = order.order_items.create!(
        product: product,
        quantity: quantity,
        unit_price: product.price,
        price: product.price
      )
      order.total_price += item.quantity * item.price
    end
    order.save!

    payment = Payment.create!(
      order: order,
      store: store,
      amount: order.total_price,
      payment_method: %w[PayPal Stripe].sample,
      status: "paid",
      transaction_id: SecureRandom.hex(10),
      payment_date: Time.current
    )

    receipt = Receipt.create!(
      order: order,
      store: store,
      amount: order.total_price,
      content: "Receipt for Order ##{order.id}",
      receipt_type: "store"
    )

    begin
      ReceiptMailer.send_receipt_to_customer(receipt).deliver_now
      ReceiptMailer.send_receipt_to_store(receipt).deliver_now
      ReceiptMailer.send_receipt_to_business(receipt).deliver_now
    rescue => e
      puts "⚠️ Email error for Order ##{order.id}: #{e.message}"
    end

    puts "✅ Order ##{order.id} | Payment: #{payment.amount} | Receipt: #{receipt.content}"
  end
end

# Generate receipts and random refunds
puts "Generating receipts and refunds..."

Order.find_each do |order|
  unless Receipt.exists?(order_id: order.id)
    Receipt.create!(
      order: order,
      store: order.store,
      amount: order.total_price,
      content: "Generated Receipt for Order ##{order.id}",
      receipt_type: "store",
      issued_at: Time.current
    )
    puts "🧾 Generated receipt for Order ##{order.id}"
  end

  if [true, false].sample
    refund_amount = rand(1..(order.total_price * 0.5)).round(2)
    Refund.create!(
      order: order,
      store: order.store,
      amount: refund_amount,
      reason: ["Product damaged", "Late delivery", "Customer complaint"].sample,
      refund_date: Time.current
    )
    puts "💸 Refund issued for Order ##{order.id} - Amount: #{refund_amount}"
  end
end

puts "✅ Receipts and refunds generation completed."
puts "🌱 Seed data created successfully!"
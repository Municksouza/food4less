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
  puts "⚠️ Arquivo de logo não encontrado em #{logo_path}. Verifique o caminho e a existência do arquivo."
end

# Create 2 business_admins
2.times do
  email = Faker::Internet.email
  business_admin = BusinessAdmin.new(
    name: Faker::Company.name,
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.phone_number,
    zip_code: Faker::Address.zip_code,
    email: email,
    password: "123456",
    password_confirmation: "123456",
  )
  business_admin.logo.attach(
    io: File.open(logo_path),
    filename: 'placeholder.jpeg',
    content_type: 'image/jpeg'
  ) if File.exist?(logo_path)

  business_admin.save!
  puts "✅ BusinessAdmin created: #{email} | password: 123456"

  3.times do
    store = business_admin.stores.create(
      name: Faker::Company.name,
      address: Faker::Address.full_address,
      phone: Faker::PhoneNumber.phone_number,
      zip_code: Faker::Address.zip_code,
      email: Faker::Internet.email,
      description: Faker::Company.catch_phrase,
      status: "active"
    )

    if File.exist?(logo_path)
      store.logo.attach(
        io: File.open(logo_path),
        filename: 'placeholder.jpeg',
        content_type: 'image/jpeg'
      )
    end
    store.save!
    puts "✅ Loja '#{store.name}' criada com sucesso."

    # Create StoreManager for each store
    store_manager_email = "manager_#{store.id}@store.com"
    StoreManager.create!(
      email: store_manager_email,
      password: "123456",
      store: store
    )
    puts "✅ StoreManager created: #{store_manager_email} | password: 123456"

    # Create products
    5.times do
      product = store.products.create!(
        name: Faker::Commerce.product_name,
        description: Faker::Lorem.sentence,
        old_price: Faker::Commerce.price(range: 30..100),
        price: Faker::Commerce.price(range: 10..30),
        stock: rand(10..100)
      )

      if File.exist?(logo_path)
        product.images.attach(
          io: File.open(logo_path),
          filename: 'placeholder.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end

# Create 5 customers
5.times do
  email = Faker::Internet.unique.email
  customer = Customer.create!(
    name: Faker::Name.name,
    email: email,
    phone: Faker::PhoneNumber.phone_number,
    password: "123456",
    password_confirmation: "123456",
  )

  customer.photo.attach(
    io: File.open(logo_path),
    filename: 'placeholder.jpeg',
    content_type: 'image/jpeg'
  ) if File.exist?(logo_path)

  puts "✅ Customer created: #{email} | password: 123456"
end

# Create orders, payments, receipts, and refunds
Customer.all.each do |customer|
  2.times do
    store = Store.order(Arel.sql("RANDOM()")).first || next
    order = customer.orders.create!(
      store: store,
      total_price: 0.0,
      status: "pending"
    )

    3.times do
      product = store.products.order(Arel.sql("RANDOM()")).first || next
      quantity = rand(1..3)
      item = order.order_items.create!(
        product: product,
        quantity: quantity,
        unit_price: product.price,
        price: product.price,
      )
      order.total_price += item.quantity * item.price
    end
    order.save!

    # Payment
    payment = Payment.create!(
      order: order,
      store: store,
      amount: order.total_price,
      payment_method: %w[PayPal Stripe].sample,
      status: "paid",
      transaction_id: SecureRandom.hex(10),
      payment_date: Time.current
    )

    # Receipt
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
    rescue StandardError => e
      puts "⚠️ Failed to send receipt emails for Order ##{order.id}: #{e.message}"
    end

    puts "✅ Order ##{order.id} created with total price: #{order.total_price}"
    puts "✅ Payment created for Order ##{order.id} with amount: #{payment.amount}"
    puts "✅ Receipt created for Order ##{order.id} with content: #{receipt.content}"
  end
end

# Geração de recibos e reembolsos complementares
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
    puts "🧾 Created receipt for Order ##{order.id}"
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
    puts "💸 Refund created for Order ##{order.id} - Amount: #{refund_amount}"
  end
end

puts "✅ Receipts and refunds generation completed."
puts "🌱 Seed data created successfully!"

if BusinessAdmin.any?
  business_admin = BusinessAdmin.first

  extra_stores = [
    {
      name: "Fresh Mart East",
      address: "270 Acadia Dr, Saskatoon, SK",
      zip_code: "S7H 3V4"
    },
    {
      name: "Budget Foods",
      address: "501 22nd St E, Saskatoon, SK",
      zip_code: "S7K 0H2"
    },
    {
      name: "North End Grocery",
      address: "134 Primrose Dr, Saskatoon, SK",
      zip_code: "S7K 5S6"
    }
  ]

  # Create additional stores with real addresses
  extra_stores.each do |data|
    store = business_admin.stores.new(
      name: data[:name],
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.phone_number,
      address: data[:address],
      zip_code: data[:zip_code],
      description: Faker::Company.catch_phrase,
      status: "active"
    )

    store.logo.attach(
      io: File.open(logo_path),
      filename: 'placeholder.jpeg',
      content_type: 'image/jpeg'
    ) if File.exist?(logo_path)

    store.geocode if store.respond_to?(:geocode)

    store.save!

    puts "📍 Store com endereço real adicionada: #{store.name} - #{store.address}, #{store.zip_code}"
  end
end
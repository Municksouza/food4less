# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Data cleanup
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
    business_admin = BusinessAdmin.new(
        name: Faker::Company.name,
        address: Faker::Address.full_address,
        phone: Faker::PhoneNumber.phone_number,
        zip_code: Faker::Address.zip_code,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
    )
    if File.exist?(logo_path)
        business_admin.logo.attach(
          io: File.open(logo_path),
          filename: 'placeholder.jpeg',
          content_type: 'image/jpeg'
        )
    end
    business_admin.save!

    puts "✅ Administrador de Negócios '#{business_admin.name}' criado com sucesso."

    3.times do
        store = business_admin.stores.create(
            name: Faker::Company.name,
            address: Faker::Address.full_address,
            phone: Faker::PhoneNumber.phone_number,
            zip_code: Faker::Address.zip_code,
            email: Faker::Internet.email,
            description: Faker::Company.catch_phrase
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
        StoreManager.create!(
            email: "manager_#{store.id}@store.com",
            password: "123456",
            store: store
        )

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
    customer = Customer.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      phone: Faker::PhoneNumber.phone_number,
      password: "123456",
      password_confirmation: "123456",
    )
  
    if File.exist?(logo_path)
      customer.photo.attach(
        io: File.open(logo_path),
        filename: 'placeholder.jpeg',
        content_type: 'image/jpeg'
      )
    end
end
puts "✅ Clientes criados com sucesso."

# Create orders, payments, and receipts
Customer.all.each do |customer|
    2.times do
        store = Store.order(Arel.sql("RANDOM()")).first || next
        order = customer.orders.create!(
            store: store,
            total_price: 0.0,
            status: 'accepted'
        )

        3.times do
            product = store.products.order(Arel.sql("RANDOM()")).first || next
            quantity = rand(1..3)
            item = order.order_items.create!(
                product: product,
                quantity: quantity,
                price: product.price
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
        end
end

puts "🌱 Seed data created successfully!"

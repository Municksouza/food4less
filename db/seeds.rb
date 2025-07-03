require 'faker'
require 'securerandom'

puts "🧹 Cleaning old records..."
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
Category.destroy_all
puts "✅ Data cleanup completed."

def secure_password
  "#{Faker::Internet.password(min_length: 6, mix_case: true)}1!"
end

puts "🌱 Creating categories..."
%w[Italian Chinese Indian Mexican Japanese French Brazilian Thai Greek Spanish].each do |name|
  Category.find_or_create_by!(name: name)
end

puts "🌱 Creating BusinessAdmin..."
admin = BusinessAdmin.create!(
  email: "admin@marketgroup.com",
  name: "MarketGroup Inc.",
  phone: "306-555-9999",
  zip_code: "S7K 0H2",
  address: "Main Office - Saskatoon, SK",
  password: "Admin123!",
  password_confirmation: "Admin123!",
  business_number: "#{rand(1..9)}#{Array.new(8) { rand(0..9) }.join}"
)
admin.logo.attach(
  io: File.open(Rails.root.join("app", "assets", "images", "placeholder.jpeg"), "rb"),
  filename: "admin-logo.jpg",
  content_type: "image/jpeg"
)
puts "✅ BusinessAdmin created."

puts "🌱 Creating stores and products..."
saskatoon_streets = ["20th St W", "Broad St", "3rd Ave N", "8th St E", "Attridge Dr", "Circle Dr N"]
["Westside Market", "Southside Grocers", "Eastside Foods"].each_with_index do |store_name, i|
  address = "#{rand(100..999)} #{saskatoon_streets[i % saskatoon_streets.length]}, Saskatoon, SK"
  store = Store.new(
    name: store_name,
    address: address,
    zip_code: "S7K 0H2",
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    description: Faker::Company.catch_phrase,
    status: "active",
    receive_notifications: true,
    business_admin: admin
  )
  store.logo.attach(
    io: File.open(Rails.root.join("app", "assets", "images", "placeholder.jpeg"), "rb"),
    filename: "logo-#{store_name.parameterize}.jpeg",
    content_type: "image/jpeg"
  )
  store.save(validate: false)
  store.geocode_address if store.respond_to?(:geocode_address)

  StoreManager.create!(
    email: "manager_#{store.id}@demo.com",
    store: store,
    receive_notifications: true,
    password: "Manager123!",
    password_confirmation: "Manager123!",
    business_admin: admin
  )

  5.times do
    old_price = Faker::Commerce.price(range: 20.0..100.0)
    price = (old_price * 0.75).round(2)
    product = store.products.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Food.description,
      old_price: old_price,
      price: price,
      stock: rand(10..100),
      category: Category.order("RANDOM()").first
    )
    product.images.attach(
      io: File.open(Rails.root.join("app", "assets", "images", "placeholder.jpeg"), "rb"),
      filename: "prod-#{product.id}.jpeg",
      content_type: "image/jpeg"
    )
  end
end

puts "🌱 Creating customers..."
5.times do
  name = Faker::Name.name
  customer = Customer.create!(
    name: name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    password: "Client123!",
    password_confirmation: "Client123!"
  )
  customer.photo.attach(
    io: File.open(Rails.root.join("app", "assets", "images", "placeholder.jpeg"), "rb"),
    filename: "avatar-#{customer.id}.jpg",
    content_type: "image/jpeg"
  )
end

puts "🌱 Creating orders, receipts, refunds..."
Customer.find_each do |customer|
  2.times do
    store = Store.order("RANDOM()").first
    order = customer.orders.create!(store: store, total_price: 0.0, status: "pending")

    3.times do
      product = store.products.order("RANDOM()").first
      qty = rand(1..3)
      item = order.order_items.create!(
        product: product,
        quantity: qty,
        unit_price: product.price,
        price: product.price * qty
      )
      order.total_price += item.price
    end
    order.save!

    payment = Payment.create!(
      order:          order,
      store:          store,
      amount:         order.total_price,
      payment_method: %w[PayPal Stripe].sample,
      status:         'paid',
      transaction_id: SecureRandom.hex(10),
      payment_date:   Time.current
    )
    puts "💳 Payment saved: Order ##{order.id} => Payment ID ##{payment.id}" if order.payment.present?

    receipt = Receipt.create!(
      order:        order,
      store:        store,
      amount:       order.total_price,
      content:      "Receipt for Order ##{order.id}",
      receipt_type: 'store',
      issued_at:    Time.current
    )

    [
      -> { ReceiptMailer.send_receipt_to_customer(receipt).deliver_later },
      
    ].each do |mail|
      begin
        mail.call
      rescue => e
        puts "⚠️ Email error: #{e.message}"
      end
      puts "📧 Sent receipt emails for Order ##{order.id}"
    end

    if [true, false].sample
      refund_amount = (order.total_price * rand(0.1..0.5)).round(2)
      Refund.create!(
        order:       order,
        store:       store,
        amount:      refund_amount,
        reason:      %w[Product\ damaged Late\ delivery Customer\ complaint].sample,
        refund_date: Time.current
      )
      puts "💸 Refund for Order ##{order.id} - Amount: #{refund_amount}"
    end
  end
end

puts "🌱 Adding reviews..."
Product.find_each do |product|
  rand(1..3).times do
    Review.create!(
      title:    Faker::Lorem.sentence(word_count: 3),
      product:  product,
      store:    product.store,
      customer: Customer.order("RANDOM()").first,
      order:    product.order_items.sample&.order || Order.order("RANDOM()").first,
      comment:  Faker::Lorem.paragraph(sentence_count: 2),
      rating:   rand(1..5)
    )
  end
end

Testimonial.create!([
  { quote: "Easy to order, and I picked up a hot meal in minutes. I love it!", author: "Emily R." },
  { quote: "Great local deals and quick pickup. Very convenient!", author: "Jamal S." },
  { quote: "I save money and reduce waste. Win-win!", author: "Sophie L." },
  { quote: "The app is user-friendly, and the food is always fresh!", author: "Carlos M." },
  { quote: "I love the variety of meals available. Highly recommend!", author: "Tina W." },
  { quote: "The pickup process is seamless. I’m a fan!", author: "Nina K." },
  { quote: "I love supporting local businesses while saving money!", author: "Jake P." },
  { quote: "The food is always delicious and fresh. I’m hooked!", author: "Lily A." },
  { quote: "I can’t believe how easy it is to get great food at a discount!", author: "Sam D." }
])

puts "✅ Seeding complete!"
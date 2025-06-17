# Food4Less – Marketplace for Discounted Restaurant Food

**Food4Less** is a full-stack platform where customers can purchase surplus or discounted meals from local restaurants. Inspired by real-world apps, it features real-time order management, payment split logic, and PDF invoice generation.

## 🧠 Key Features
- Role-based access with Devise (Customers, Stores, Business Admins)
- Live order tracking via ActionCable (WebSockets)
- Stripe Connect + PayPal payment support (split, refund, invoice, receipt)
- Store dashboard with real-time order acceptance/rejection
- Business-level reporting and oversight (no order handling)
- Invoice generation (PDF download)
- Ratings and reviews for products and stores
- Secure authentication, seed data, and test coverage

## 💻 Technologies
- Ruby on Rails 8
- PostgreSQL / SQLite3 (dev)
- StimulusJS + Vite
- Stripe API, PayPal API
- PDFKit for invoices
- RSpec + FactoryBot for testing
- Deployed on Render

## 📂 Setup Instructions
```bash
git clone https://github.com/Municksouza/food4less.git
cd food4less
bundle install
yarn install
rails db:setup
rails s

# 🍽️ Food4Less – Full-Stack Marketplace for Restaurants and Surplus Food

**Food4Less** is a full-stack web application built with **Ruby on Rails** and **StimulusJS**, designed to connect customers to local restaurants offering discounted food for pickup. The platform features real-time order management, Stripe Connect payment splitting, and PDF invoice generation.

## 🧠 Features
- Role-based authentication (Customers, Stores, Business Admins)
- Real-time dashboard updates with ActionCable (order acceptance, status changes)
- Stripe & PayPal integration (split payments, refunds, receipts)
- Store management: products, categories, preparation times
- Customer-friendly UI with modern design and responsiveness
- Downloadable PDF invoices for both customer and store
- Product reviews and store rating system
- Business Admin dashboard with store management, reporting and oversight

---

## 🛠 Tech Stack

**Backend:**  
- Ruby on Rails 8  
- Devise for authentication  
- ActiveStorage for file uploads  
- ActionCable for real-time features  
- FriendlyId for clean URLs  
- PDFKit for invoice generation

**Frontend:**  
- StimulusJS  
- SCSS with PostCSS and Autoprefixer  
- Bootstrap 5 + Bootstrap Icons  
- AOS.js (scroll animations)  
- Swiper & Slick Carousel for product sliders  
- Chart.js + Chartkick for analytics

**Maps & Geolocation:**  
- Mapbox GL  
- Mapbox SDK + Geocoder

**Payments:**  
- Stripe Connect  
- PayPal SDK  
- Webhooks for event handling  
- Refund & invoice logic

---

## ⚙️ Project Setup

### 🧪 Running Locally

```bash
# Clone the repository
git clone https://github.com/Municksouza/food4less.git
cd food4less

# Install Ruby and JS dependencies
bundle install
yarn install

# Set up the database
rails db:setup

# Run the app
rails s
```

### 🧰 Build Commands

```bash
# Full asset build (CSS + JS)
yarn build

# Watch for JS changes
yarn watch

# Watch for CSS changes
yarn watch:css
```

---

## 📁 Directory Overview

```
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   ├── javascript/       # Stimulus controllers
│   ├── assets/
│   │   ├── stylesheets/
│   │   └── builds/
│   └── channels/         # ActionCable
├── config/
├── db/
├── bin/
├── public/
├── package.json
└── README.md
```

---

## ✅ Scripts from `package.json`

```json
{
  "scripts": {
    "build": "yarn build:css && yarn build:js && mkdir -p public/assets",
    "build:js": "node bin/esbuild.cjs",
    "build:css:compile": "sass ./app/assets/stylesheets/application.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules",
    "build:css:prefix": "postcss ./app/assets/builds/application.css --use=autoprefixer --output=./app/assets/builds/application.css",
    "build:css": "yarn build:css:compile && yarn build:css:prefix",
    "watch": "node bin/esbuild.cjs --watch --bundle",
    "watch:css": "nodemon --watch ./app/assets/stylesheets/ --ext scss --exec \"yarn build:css\""
  }
}
```

---

## 👩🏻‍💻 Developer

**Munick Souza**  
📍 Saskatoon, SK  
🔗 [GitHub](https://github.com/Municksouza) | [LinkedIn](https://linkedin.com/in/munick-souza)  
📫 [munick.freitas@hotmail.com](mailto:munick.freitas@hotmail.com)


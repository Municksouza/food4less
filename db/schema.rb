# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_02_185805) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "business_admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "address"
    t.string "zip_code"
    t.string "phone"
    t.string "logo"
    t.string "business_number"
    t.index ["email"], name: "index_business_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_business_admins_on_reset_password_token", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id", null: false
    t.index ["customer_id"], name: "index_carts_on_customer_id"
    t.index ["store_id"], name: "index_carts_on_store_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cuisines", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "order_histories", force: :cascade do |t|
    t.string "status"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_histories_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "price"
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "unit_price"
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "status"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_statuses_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "customer_id", null: false
    t.decimal "total_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_amount"
    t.integer "ready_in_minutes"
    t.text "note"
    t.integer "preparation_time"
    t.datetime "countdown_end_time"
    t.integer "status", default: 0
    t.datetime "finalized_at"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "taxes", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_with_taxes", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["id"], name: "index_orders_on_id", unique: true
    t.index ["store_id"], name: "index_orders_on_store_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "payment_method"
    t.string "status"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id", null: false
    t.decimal "amount"
    t.datetime "payment_date"
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["store_id"], name: "index_payments_on_store_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.decimal "old_price"
    t.integer "stock"
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "discount_price"
    t.boolean "active", default: true
    t.bigint "category_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.string "receipt_type", null: false
    t.text "content", null: false
    t.bigint "order_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.datetime "issued_at"
    t.bigint "business_admin_id"
    t.index ["business_admin_id"], name: "index_receipts_on_business_admin_id"
    t.index ["order_id"], name: "index_receipts_on_order_id"
    t.index ["store_id"], name: "index_receipts_on_store_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "refund_date", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id", null: false
    t.string "reason"
    t.index ["order_id"], name: "index_refunds_on_order_id"
    t.index ["store_id"], name: "index_refunds_on_store_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "comment"
    t.bigint "order_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.string "title"
    t.index ["customer_id"], name: "index_reviews_on_customer_id"
    t.index ["order_id"], name: "index_reviews_on_order_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["store_id"], name: "index_reviews_on_store_id"
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "job_class", null: false
    t.text "arguments"
    t.datetime "scheduled_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.datetime "started_at", precision: nil
    t.string "status", default: "enqueued", null: false
    t.text "error"
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.integer "priority", default: 0, null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["priority"], name: "index_solid_queue_jobs_on_priority"
    t.index ["queue_name"], name: "index_solid_queue_jobs_on_queue_name"
    t.index ["scheduled_at"], name: "index_solid_queue_jobs_on_scheduled_at"
    t.index ["status"], name: "index_solid_queue_jobs_on_status"
  end

  create_table "store_managers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.boolean "receive_notifications"
    t.bigint "business_admin_id", null: false
    t.index ["business_admin_id"], name: "index_store_managers_on_business_admin_id"
    t.index ["email"], name: "index_store_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_store_managers_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_store_managers_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "zip_code"
    t.string "manager_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_admin_id"
    t.string "email"
    t.text "description"
    t.float "latitude"
    t.float "longitude"
    t.string "status"
    t.boolean "active", default: true
    t.boolean "receive_notifications", default: false, null: false
    t.bigint "cuisine_id"
    t.string "business_number"
    t.integer "category_id"
    t.string "slug"
    t.index ["cuisine_id"], name: "index_stores_on_cuisine_id"
    t.index ["slug"], name: "index_stores_on_slug", unique: true
  end

  create_table "super_admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
  end

  create_table "testimonials", force: :cascade do |t|
    t.string "quote"
    t.string "author"
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "customers"
  add_foreign_key "carts", "stores"
  add_foreign_key "order_histories", "orders"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "order_statuses", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "stores"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "stores"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "stores"
  add_foreign_key "receipts", "business_admins"
  add_foreign_key "receipts", "orders"
  add_foreign_key "receipts", "stores"
  add_foreign_key "refunds", "orders"
  add_foreign_key "refunds", "stores"
  add_foreign_key "reviews", "customers"
  add_foreign_key "reviews", "orders"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "stores"
  add_foreign_key "store_managers", "business_admins"
  add_foreign_key "store_managers", "stores"
  add_foreign_key "stores", "business_admins"
  add_foreign_key "stores", "cuisines"
end

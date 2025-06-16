# # lib/tasks/fixture_reset.rake
# namespace :db do
#   desc "Clear all tables before loading fixtures"
#   task :clean_and_load => :environment do
#     [
#       "cart_items",
#       "carts",
#       "products",
#       "stores",
#       "customers",
#       "categories",
#       "business_admins"
#     ].each do |table|
#       ActiveRecord::Base.connection.execute("DELETE FROM #{table};")
#     end

#     puts "Tables cleaned. Now load fixtures one by one."
#   end
# end
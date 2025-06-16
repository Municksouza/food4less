# # lib/tasks/test_setup.rake
# namespace :db do
#   desc "Force-load fixtures ignoring foreign key constraints"
#   task :safe_fixtures_load => :environment do
#     ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")
#     Rake::Task["db:fixtures:load"].invoke
#     ActiveRecord::Base.connection.execute("SET session_replication_role = origin;")
#   end
# end
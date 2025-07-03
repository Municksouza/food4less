namespace :active_storage do
  desc "Migrate all local ActiveStorage blobs to Cloudinary"
  task migrate_to_cloudinary: :environment do
    require "open-uri"

    ActiveStorage::Blob.where(service_name: "local").find_each do |blob|
      begin
        puts "Processing blob: #{blob.filename} (#{blob.id})"

        # Download the file from local disk
        local_file = open(blob.service.send(:path_for, blob.key))

        # Upload it to Cloudinary
        new_blob = ActiveStorage::Blob.create_and_upload!(
          io: local_file,
          filename: blob.filename,
          content_type: blob.content_type,
          service_name: "cloudinary"
        )

        # Reattach to the original record
        blob.attachments.each do |attachment|
          attachment.update!(blob: new_blob)
        end

        # Optional: Delete the old blob
        blob.purge
        puts "✅ Migrated and purged: #{blob.filename}"

      rescue => e
        puts "❌ Error migrating blob #{blob.filename}: #{e.message}"
      end
    end

    puts "🎉 Migration to Cloudinary completed!"
  end
end
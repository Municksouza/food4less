# lib/tasks/active_storage_cleanup.rake

namespace :active_storage do
  desc "Remove orphaned ActiveStorage blobs that are not attached to any record"
  task clean_orphaned_blobs: :environment do
    orphaned = ActiveStorage::Blob.left_outer_joins(:attachments).where(active_storage_attachments: { id: nil })

    puts "Found #{orphaned.count} orphaned blob(s)"
    orphaned.find_each do |blob|
      puts "Deleting orphaned blob: #{blob.filename}"
      blob.purge
    end
  end
end
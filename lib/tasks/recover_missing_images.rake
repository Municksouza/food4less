# lib/tasks/recover_missing_images.rake
namespace :active_storage do
    desc "Recover product images with missing blobs on disk"
    task recover_missing_product_images: :environment do
        require 'open-uri'

        puts "🔍 Searching for product images with missing files..."

        missing_count = 0

        Product.find_each do |product|
            product.images.each do |image|
                blob = image.blob
                service = ActiveStorage::Blob.services.fetch(blob.service_name)

                begin
                    # Check if the file physically exists in storage
                    service.send(:path_for, blob.key).tap do |path|
                        unless File.exist?(path)
                            puts "🚫 Missing file for #{blob.filename} (Product ##{product.id})"
                            image.purge

                            # Download new image
                            seed = "recover-#{product.id}-#{blob.id}"
                            url  = "https://picsum.photos/seed/#{seed}/300/300"
                            file = URI.open(url)

                            product.images.attach(
                                io:           file,
                                filename:     "prod-#{product.id}.jpg",
                                content_type: "image/jpeg"
                            )

                            product.save!
                            puts "✅ Image recreated for Product ##{product.id}"
                            missing_count += 1
                        end
                    end
                rescue => e
                    puts "⚠️ Error checking or recovering image for Product ##{product.id}: #{e.message}"
                end
            end
        end

        puts "🎉 Process finished. #{missing_count} image(s) were recreated."
    end
end

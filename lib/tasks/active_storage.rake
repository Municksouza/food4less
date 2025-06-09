# lib/tasks/active_storage.rake

namespace :active_storage do
    desc "Force recreation of product images even if they are present"
    task force_recreate_all_product_images: :environment do
        require 'open-uri'

        puts "🧼 Cleaning old images..."
        Product.find_each do |product|
            next unless product.images.attached?
            product.images.purge
        end

        puts "🔄 Recreating images for products..."

        recreated = 0

        Product.find_each do |product|
            img_url = "https://picsum.photos/seed/recreate-#{product.id}/300/300"
            filename = "prod-#{product.id}.jpg"

            begin
                file = URI.open(img_url)
                product.images.attach(
                    io: file,
                    filename: filename,
                    content_type: 'image/jpeg'
                )
                product.save!
                recreated += 1
                puts "✅ Image recreated for Product ##{product.id}"
            rescue => e
                puts "⚠️ Error recreating image for Product ##{product.id}: #{e.message}"
            end
        end

        puts "🎉 Process finished. #{recreated} image(s) were recreated."
    end
end

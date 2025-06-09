namespace :aos do
  desc "Insere data-aos nas views com sections comuns"
  task apply: :environment do
    patterns = {
      /<section class="hero-split-section/            => 'data-aos="fade-up"',
      /<div class="products-carousel-wrapper/         => 'data-aos="fade-up" data-aos-delay="200"',
      /<section class="testimonial-banner-section/    => 'data-aos="fade-up" data-aos-delay="300"',
      /<section class="pickup-map-section/            => 'data-aos="zoom-in" data-aos-delay="400"'
    }

    changed_files = []

    patterns.each do |pattern, attr|
      Dir.glob("app/views/**/*.html.erb").each do |file|
        text = File.read(file)
        new_text = text.gsub(pattern) do |match|
          match.include?('data-aos=') ? match : match.sub(/>$/, " #{attr}>")
        end

        if new_text != text
          File.write(file, new_text)
          changed_files << file
        end
      end
    end

    puts "✅ Atributos data-aos inseridos nos arquivos:"
    changed_files.each { |f| puts "🟢 #{f}" }
  end
end
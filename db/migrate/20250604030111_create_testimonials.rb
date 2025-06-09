class CreateTestimonials < ActiveRecord::Migration[7.0]
  def change
    create_table :testimonials do |t|
      t.string :quote
      t.string :author
      t.boolean :visible, default: true

      t.timestamps
    end
  end
end
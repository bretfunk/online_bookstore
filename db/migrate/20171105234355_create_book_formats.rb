class CreateBookFormats < ActiveRecord::Migration[5.1]
  def change
    create_table :book_formats do |t|
      t.references :book, foreign_key: true
      t.references :book_format_type, foreign_key: true

      t.timestamps
    end
  end
end

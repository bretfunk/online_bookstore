class CreateBookReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :book_reviews do |t|
      t.integer :rating
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end

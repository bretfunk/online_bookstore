class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher
  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, through: :book_formats


  def self.search(query, options)
  end

  def book_format_typez
    #byebug
    book_format_types.distinct.pluck(:name)
  end

  def author_name
    "#{author.last_name}, #{author.first_name}"
  end

  def average_rating
    (book_reviews.sum(:rating) / book_reviews.count).round(1)
  end
end

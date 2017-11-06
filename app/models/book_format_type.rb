class BookFormatType < ApplicationRecord
  has_many :book_formats
  has_many :books, through: :book_formats
end

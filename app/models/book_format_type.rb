class BookFormatType < ApplicationRecord
  has_many :book_formats
  has_many :book_format_types, through: :book_formats
end

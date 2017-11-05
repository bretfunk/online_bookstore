class BookFormat < ApplicationRecord
  belongs_to :book
  belongs_to :book_format_type
end

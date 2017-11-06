class BookReview < ApplicationRecord
  validates :rating, presence: true
  belongs_to :book
end

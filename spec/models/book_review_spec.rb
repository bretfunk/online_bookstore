require 'rails_helper'

RSpec.describe BookReview, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      book = create(:book)
      create_list(:book_review, 3, book_id: book.id)

      expect(book.book_reviews.first).to be_valid
      expect(book.book_reviews.first.rating).to eq(5)
      expect(book.book_reviews.first.book_id).to eq(book.id)
    end

    it "is invalid with invalid attributes" do
      book = Book.create()
      expect(book).to_not be_valid
    end
    it { should validate_presence_of(:rating) }
  end

  context "associations" do
    it { should belong_to(:book) }
  end
end

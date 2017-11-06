require 'rails_helper'

RSpec.describe BookFormat, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      book = create(:book)
      book_format_type = create(:book_format_type)
      book_format = create(:book_format, book_id: book.id, book_format_type_id: book_format_type.id)

      expect(book_format).to be_valid
      expect(book_format.book_id).to eq(book.id)
      expect(book_format.book_format_type_id).to eq(book_format_type.id)
    end
  end

  context "associations" do
    it { should belong_to(:book) }
    it { should belong_to(:book_format_type) }
  end
end

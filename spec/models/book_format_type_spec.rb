require 'rails_helper'

RSpec.describe BookFormatType, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      book = create(:book)
      book_format_type = create(:book_format_type)
      create(:book_format, book_id: book.id, book_format_type_id: book_format_type.id)

      expect(book_format_type).to be_valid
      expect(book_format_type.name).to eq("Kindle")
      expect(book_format_type.physical).to eq(false)
      expect(book_format_type.books.first.title).to eq("BookTitle")

    end
  end

  context "associations" do
    it { should have_many(:book_formats) }
    it { should have_many(:books) }
  end
end

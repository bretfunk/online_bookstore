require 'rails_helper'

RSpec.describe Book, type: :model do
  context "attributes" do
    it "is valid with valid attributes" do
      author = create(:author)
      publisher = create(:publisher)
      book = create(:book, publisher_id: publisher.id, author_id: author.id)
      book_format_types = create_list(:book_format_type, 3)
      create_list(:book_review, 3, book_id: book.id)
      book.book_format_types << book_format_types

      expect(book).to be_valid
      expect(book.publisher).to be_valid
      expect(book.author).to be_valid
      expect(book.title).to eq("BookTitle")
      expect(book.publisher.name).to eq(publisher.name)
      expect(book.author.first_name).to eq(author.first_name)
      expect(book.author.last_name).to eq(author.last_name)
      expect(book.book_format_types.count).to eq(3)
      expect(book.book_reviews.count).to eq(3)
    end
  end

  it "is invalid with invalid attributes" do
    book = Book.create()
    expect(book).to_not be_valid
  end

  context "assocations" do
    it { should belong_to(:publisher) }
    it { should belong_to(:author) }
    it { should have_many(:book_reviews) }
    it { should have_many(:book_formats) }
    it { should have_many(:book_format_types) }
  end

  context "methods" do
    it "has function instance methods" do
      author = create(:author, first_name: "Ryan", last_name: "Holiday")
      book = create(:book, author_id: author.id)

      #author_name
      expect(book.author_name).to eq("Holiday, Ryan")

      book_format_type1 = create(:book_format_type, name: "Hardcover")
      book_format_type2 = create(:book_format_type, name: "Softcover")
      book_format_type3 = create(:book_format_type, name: "Kindle")
      create(:book_format, book_id: book.id, book_format_type_id: book_format_type1.id)
      create(:book_format, book_id: book.id, book_format_type_id: book_format_type2.id)
      create(:book_format, book_id: book.id, book_format_type_id: book_format_type3.id)

      #book_format_types
      expect(book.book_format_types).to eq('["Hardcover", "Softcover", Kindle"]')

      rating1 = create(:book_review, rating: 5)
      rating1 = create(:book_review, rating: 3)
      rating1 = create(:book_review, rating: 1)

      #average_rating
      expect(book.average_rating).to eq(3)

    end
  end
end

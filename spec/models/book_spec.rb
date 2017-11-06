require 'rails_helper'

RSpec.describe Book, type: :model do
  context "attributes" do
    it "is valid with valid attributes" do
      author = create(:author)
      publisher = create(:publisher)
      book = create(:book, publisher_id: publisher.id, author_id: author.id)

      expect(book).to be_valid
      expect(book.publisher).to be_valid
      expect(book.author).to be_valid
      expect(book.title).to eq("BookTitle")
      expect(book.publisher.name).to eq(publisher.name)
      expect(book.author.first_name).to eq(author.first_name)
      expect(book.author.last_name).to eq(author.last_name)
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
end

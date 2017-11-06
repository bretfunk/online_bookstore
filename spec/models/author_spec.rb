require 'rails_helper'

RSpec.describe Author, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      author = create(:author)
      create_list(:book, 3, author_id: author.id)
      expect(author).to be_valid
      expect(author.first_name).to eq("FirstName")
      expect(author.last_name).to eq("LastName")
      expect(author.books.count).to eq(3)

    end
  end

  context "associations" do
    it { should have_many(:books) }
  end
end

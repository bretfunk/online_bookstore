require 'rails_helper'

RSpec.describe Publisher, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      publisher = create(:publisher)
      create_list(:book, 3, publisher_id: publisher.id)

      expect(publisher).to be_valid
      expect(publisher.name).to eq("Publisher")
      expect(publisher.books.count).to eq(3)
    end
  end

  context "associations" do
    it { should have_many(:books) }
  end
end

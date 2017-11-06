class Book < ApplicationRecord
  validates :title, presence: true
  belongs_to :author
  belongs_to :publisher
  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, through: :book_formats

  def self.search(query, options)
    new_options = {
      title_only: options[:title_only] || false,
      book_format_type_id: options[:book_format_type_id] || nil,
      book_format_physical: options[:book_format_physical] || nil
    }

    if new_options[:title_only] && new_options[:book_format_physical]
      BookFormatType
        .joins(:books)
        .select("books.*")
        .where(physical: true)
        .where(title: "%#{query}%")

    elsif new_options[:title_only]
      (Book.where("title LIKE (?)", "%#{query}%") ||
      Author.where(last_name: query).books ||
      Publisher.where(title: query).books)
        .order("rating DESC").distinct

    elsif new_options[:book_format_type_id]
      BookFormatType.joins(:books).select("books.*").where(id: query)

    elsif new_options[:book_format_physical]
      BookFormatType.joins(:books).select("books.*").where(physical: true).where(name: query)
    end
  end

  #def book_format_types
    #super.distinct.pluck(:name)
  #end

  def author_name
    "#{author.last_name}, #{author.first_name}"
  end

  def average_rating
    (book_reviews.sum(:rating) / book_reviews.count).round(1)
  end
end

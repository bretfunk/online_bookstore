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
    new.search_selector(new_options, query)
  end

  def search_selector(new_options, query)
    if new_options[:title_only] && new_options[:book_format_physical]
    elsif new_options[:title_only]
      title_search(query)
    elsif new_options[:book_format_type_id]
      book_format_search(query)
    elsif new_options[:book_format_physical]
      physical_book_search(query)
    else
      author_publisher_search(query)
    end
  end

  def title_search(query)
    Book.where("title LIKE (?)",  "%#{query}%")
  end

  def title_and_physical_search(query)
      BookFormatType
        .joins(:books)
        .select("books.*")
        .where(physical: true)
        .where(title: "%#{query}%")
  end

  def book_format_search(query)
    BookFormatType.joins(:books).select("books.*").where(id: query)
  end

  def physical_book_search(query)
    BookFormatType.joins(:books).select("books.*").where(physical: true).where(name: query)
  end

  def author_publisher_search(query)

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

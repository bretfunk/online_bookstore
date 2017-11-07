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

  #still need case insensitive
  def search_selector(new_options, query)
    if new_options[:title_only] && new_options[:book_format_physical]
    elsif new_options[:title_only]
      title_search(query)
    elsif new_options[:book_format_type_id]
      #debugger
      book_format_search(query, new_options[:book_format_type_id])
    elsif new_options[:book_format_physical]
      physical_book_search(query, new_options[:book_format_physical])
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

  def book_format_search(query, search_id)
    author = Author.find_by(last_name: query)
    publisher = Publisher.find_by(name: query)
    if author
    Book.find_by_sql("SELECT b.* FROM books b INNER JOIN book_formats bf ON b.id = bf.book_id
                     WHERE bf.book_format_type_id = #{search_id} AND b.author_id = #{author.id}")
    elsif publisher
      Book.find_by_sql("SELECT b.* FROM books b INNER JOIN book_formats bf ON b.id = bf.book_id
                       WHERE bf.book_format_type_id = #{search_id} AND b.publisher_id = #{publisher.id}")
    end
  end

  def physical_book_search(query, physical)
    author = Author.find_by(last_name: query)
    publisher = Publisher.find_by(name: query)
    if author
    Book.find_by_sql("SELECT b.* FROM books b INNER JOIN book_formats bf ON b.id = bf.book_id
                      INNER JOIN book_format_types bft ON bf.book_format_type_id = bft.id
                     WHERE author_id = #{author.id} AND bft.physical = #{physical}")
    elsif publisher
    Book.find_by_sql("SELECT b.* FROM books b INNER JOIN book_formats bf ON b.id = bf.book_id
                      INNER JOIN book_format_types bft ON bf.book_format_type_id = bft.id
                     WHERE publisher_id = #{publisher.id} AND bft.physical = #{physical}")
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

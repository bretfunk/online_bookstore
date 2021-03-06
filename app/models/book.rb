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
    author = Author.where("lower(last_name) = ?", query.downcase).first
    publisher = Publisher.where("lower(name) = ?", query.downcase).first
    if author
      book_format_SQL_query(search_id, author, "author")
    elsif publisher
      book_format_SQL_query(search_id, publisher, "publisher")
    end
  end

  def book_format_SQL_query(search_id, object, string)
    Book.find_by_sql("SELECT b.* FROM books b INNER JOIN book_formats bf ON b.id = bf.book_id
                     WHERE bf.book_format_type_id = #{search_id} AND b.#{string}_id = #{object.id}")

  end

  def physical_book_search(query, physical)
    author = Author.where("lower(last_name) = ?", query.downcase).first
    publisher = Publisher.where("lower(name) = ?", query.downcase).first
    if author
      physical_book_SQL_query(physical, author, "author")
    elsif publisher
      physical_book_SQL_query(physical, publisher, "publisher")
    end
  end

  def physical_book_SQL_query(physical, object, string)
    Book.find_by_sql("SELECT b.* FROM books b INNER JOIN book_formats bf ON b.id = bf.book_id
                      INNER JOIN book_format_types bft ON bf.book_format_type_id = bft.id
                     WHERE #{string}_id = #{object.id} AND bft.physical = #{physical}")
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

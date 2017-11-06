class Book < ApplicationRecord
  validate :title, presence: true
  belongs_to :author
  belongs_to :publisher
  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, through: :book_formats

  #Search options:
  #:title_only (defaults to false).  If true, only return results from rule #3 above.
  #:book_format_type_id (defaults to nil).  If supplied, only return books that are available in a format that matches the supplied type id.
  #:book_format_physical (defaults to nil).   If supplied as true or false, only return books that are available in a format whose “physical” field matches the supplied argument.  This filter is not applied if the argument is not present or nil.

  #The title_only and book_format options are not exclusive of each other, so
  #Book.search('Karamazov', title_only: true, book_format_physical: true) should return all physical books whose title matches that term.

  def self.search(query, options)
    new_options = {
      title_only: options[:title_only] || false,
      book_format_type_id: options[:book_format_type_id] || nil,
      book_format_physical: options[:book_format_physical] || nil
    }
#case insensitive and distinct
    if new_options[:title_only] && new_options[:book_format_physical]
      #Book.joins(:book_format_types).where(book: { title: new_options[:title_only]}, book_format_type: { physical: true })
    elsif new_options[:title_only]
      Book.where(title: new_options[:title_only])
    elsif new_options[:book_format_type_id]
      BookFormatType.joins(:books).select("books.*").where(physical: true)
    elsif new_options[:book_format_physical]
      puts "physical?"
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

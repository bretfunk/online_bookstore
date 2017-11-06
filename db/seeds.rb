# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
author = Author.create(first_name: "Ryan", last_name: "Holiday")
publisher = Publisher.create(name: "Random House")
book = Book.create(title: "The Obstacle is the Way", author_id: author.id, publisher_id: publisher.id)
book_format_type = BookFormatType.create(name: "Kindle", physical: false)
BookFormat.create(book_id: book.id, book_format_type_id: book_format_type.id)
book.book_reviews << BookReview.create(rating: 5)

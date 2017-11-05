# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171105234437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_format_types", force: :cascade do |t|
    t.string "name"
    t.boolean "physical"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_formats", force: :cascade do |t|
    t.bigint "book_id"
    t.bigint "book_format_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_format_type_id"], name: "index_book_formats_on_book_format_type_id"
    t.index ["book_id"], name: "index_book_formats_on_book_id"
  end

  create_table "book_reviews", force: :cascade do |t|
    t.integer "rating"
    t.bigint "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_reviews_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.bigint "author_id"
    t.bigint "publisher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "book_formats", "book_format_types"
  add_foreign_key "book_formats", "books"
  add_foreign_key "book_reviews", "books"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "publishers"
end

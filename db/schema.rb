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

ActiveRecord::Schema.define(version: 2019_09_30_190924) do

  create_table "dogs", force: :cascade do |t|
    t.string "name"
    t.string "breed"
    t.string "age"
    t.text "notes"
    t.integer "owner_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.string "address"
  end

  create_table "walkers", force: :cascade do |t|
    t.string "name"
    t.integer "experience"
    t.decimal "average_rating"
  end

  create_table "walks", force: :cascade do |t|
    t.integer "dog_id"
    t.integer "walker_id"
    t.datetime "date"
    t.datetime "time"
    t.decimal "price"
    t.decimal "length"
    t.string "status"
  end

end

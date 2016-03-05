# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160305160411) do

  create_table "clues", force: :cascade do |t|
    t.text     "hint"
    t.text     "question"
    t.text     "answer"
    t.integer  "game_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "previous_clue_id"
  end

  add_index "clues", ["game_id"], name: "index_clues_on_game_id"
  add_index "clues", ["previous_clue_id"], name: "index_clues_on_previous_clue_id"

  create_table "coordinates", force: :cascade do |t|
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "clue_id"
  end

  add_index "coordinates", ["clue_id"], name: "index_coordinates_on_clue_id"

  create_table "game_histories", force: :cascade do |t|
    t.integer  "score"
    t.integer  "rank"
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "game_histories", ["game_id"], name: "index_game_histories_on_game_id"
  add_index "game_histories", ["user_id"], name: "index_game_histories_on_user_id"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "active",     default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "password"
    t.string   "firstname"
    t.string   "lastname"
  end

end

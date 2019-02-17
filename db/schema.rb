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

ActiveRecord::Schema.define(version: 2019_02_17_054246) do

  create_table "entries", force: :cascade do |t|
    t.string "race_name"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tour"
    t.index ["player_id"], name: "index_entries_on_player_id"
  end

  create_table "fours", force: :cascade do |t|
    t.string "race_name"
    t.integer "university_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tour"
    t.index ["university_id"], name: "index_fours_on_university_id"
  end

  create_table "operations", force: :cascade do |t|
    t.string "command"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operators", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pair_twos", force: :cascade do |t|
    t.integer "pair_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tour"
    t.index ["player_id"], name: "index_pair_twos_on_player_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.integer "pair_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tour"
    t.index ["player_id"], name: "index_pairs_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "year"
    t.string "u_name"
    t.string "p_name"
    t.string "typ"
    t.integer "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "universities", force: :cascade do |t|
    t.string "u_name"
    t.string "read"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "erea"
  end

end

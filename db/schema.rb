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

ActiveRecord::Schema.define(version: 2020_07_16_110153) do

  create_table "bibs", force: :cascade do |t|
    t.integer "player_id"
    t.string "bib_no"
    t.integer "tour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_bibs_on_player_id"
  end

  create_table "combination_fours", force: :cascade do |t|
    t.integer "race_id"
    t.integer "rane"
    t.string "u_name"
    t.integer "player_id1"
    t.integer "player_id2"
    t.integer "player_id3"
    t.integer "player_id4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_combination_fours_on_race_id"
  end

  create_table "combinations", force: :cascade do |t|
    t.integer "race_id"
    t.integer "rane"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_combinations_on_race_id"
  end

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
    t.integer "year"
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
    t.integer "university_id"
    t.string "reading"
    t.index ["university_id"], name: "index_players_on_university_id"
  end

  create_table "races", force: :cascade do |t|
    t.integer "year"
    t.integer "tour"
    t.integer "race_no"
    t.string "race_name"
    t.string "stage"
    t.integer "set"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ranks", force: :cascade do |t|
    t.integer "race_id"
    t.integer "rane"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_ranks_on_race_id"
  end

  create_table "remarks", force: :cascade do |t|
    t.integer "race_id"
    t.integer "rane"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_remarks_on_race_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer "race_id"
    t.integer "rane"
    t.string "m"
    t.string "s"
    t.string "c"
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_results_on_race_id"
  end

  create_table "scores", force: :cascade do |t|
    t.string "u_name"
    t.integer "year"
    t.integer "tour"
    t.float "mk_score"
    t.float "mc_score"
    t.float "m_score"
    t.float "jmk_score"
    t.float "jmc_score"
    t.float "jm_score"
    t.float "wk_score"
    t.float "wc_score"
    t.float "w_score"
    t.float "jwk_score"
    t.float "jwc_score"
    t.float "jw_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "substitutes", force: :cascade do |t|
    t.integer "main_id"
    t.string "race_name"
    t.integer "sub_id"
    t.integer "year"
    t.integer "tour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "u_name"
  end

  create_table "universities", force: :cascade do |t|
    t.string "u_name"
    t.string "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "erea"
    t.string "password_digest"
    t.string "reset_token"
  end

end

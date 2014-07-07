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

ActiveRecord::Schema.define(version: 20140705034123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_types", primary_key: "api_id", force: true do |t|
    t.string "name"
  end

  create_table "events", primary_key: "api_id", force: true do |t|
    t.string  "name"
    t.integer "venue_id"
    t.integer "event_type_id"
  end

  create_table "market_runners", force: true do |t|
    t.integer "market_id"
    t.integer "runner_id"
    t.decimal "actual_sp"
    t.string  "status"
  end

  add_index "market_runners", ["market_id"], name: "index_market_runners_on_market_id", using: :btree
  add_index "market_runners", ["runner_id"], name: "index_market_runners_on_runner_id", using: :btree

  create_table "markets", primary_key: "api_id", force: true do |t|
    t.integer  "exchange_id"
    t.string   "betting_type"
    t.datetime "start_time"
    t.string   "name"
    t.string   "market_type"
    t.integer  "event_id"
    t.string   "status",       default: "OPEN"
  end

  create_table "runners", primary_key: "api_id", force: true do |t|
    t.string "name"
  end

  create_table "venues", force: true do |t|
    t.string "country_code"
    t.string "name"
  end

  add_foreign_key "events", "event_types", name: "events_event_type_id_fk", primary_key: "api_id"
  add_foreign_key "events", "venues", name: "events_venue_id_fk"

  add_foreign_key "markets", "events", name: "markets_event_id_fk", primary_key: "api_id"

end

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

ActiveRecord::Schema.define(version: 20140704205848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_types", id: false, force: true do |t|
    t.integer "api_id",      null: false
    t.integer "primary_key"
    t.string  "name"
  end

  create_table "markets", id: false, force: true do |t|
    t.string  "api_id",        null: false
    t.string  "name"
    t.string  "market_type"
    t.integer "event_type_id"
  end

  create_table "runners", id: false, force: true do |t|
    t.integer "api_id",    null: false
    t.string  "name"
    t.string  "market_id"
  end

  add_foreign_key "markets", "event_types", name: "markets_event_type_id_fk", primary_key: "api_id"

  add_foreign_key "runners", "markets", name: "runners_market_id_fk", primary_key: "api_id"

end

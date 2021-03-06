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

ActiveRecord::Schema.define(version: 20140722212057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "event_types", primary_key: "api_id", force: true do |t|
    t.string "name"
  end

  create_table "events", primary_key: "api_id", force: true do |t|
    t.string  "name"
    t.integer "venue_id"
    t.integer "event_type_id"
  end

  create_table "market_filters", force: true do |t|
    t.string   "filter_name"
    t.string   "event_type"
    t.string   "market_type"
    t.datetime "start_date"
    t.string   "territory"
    t.string   "venue_class"
    t.string   "tier"
    t.string   "venue_name"
    t.integer  "user_id"
  end

  add_index "market_filters", ["user_id"], name: "index_market_filters_on_user_id", using: :btree

  create_table "market_runners", force: true do |t|
    t.integer "market_id"
    t.integer "runner_id"
    t.decimal "actual_sp"
    t.string  "status"
  end

  create_table "markets", force: true do |t|
    t.integer  "api_id"
    t.integer  "exchange_id"
    t.string   "betting_type"
    t.datetime "start_time"
    t.string   "name"
    t.string   "market_type"
    t.integer  "event_id"
    t.string   "status",       default: "OPEN"
  end

  create_table "old2_market_runners", force: true do |t|
    t.integer "market_id"
    t.integer "runner_id"
    t.decimal "actual_sp"
    t.string  "status"
  end

  create_table "old_market_runners", force: true do |t|
    t.integer "market_id"
    t.integer "runner_id"
    t.decimal "actual_sp"
    t.string  "status"
  end

  add_index "old_market_runners", ["market_id", "runner_id"], name: "index_old_market_runners_on_market_id_and_runner_id", unique: true, using: :btree
  add_index "old_market_runners", ["market_id"], name: "index_old_market_runners_on_market_id", using: :btree
  add_index "old_market_runners", ["runner_id"], name: "index_old_market_runners_on_runner_id", using: :btree

  create_table "old_markets", primary_key: "api_id", force: true do |t|
    t.integer  "exchange_id"
    t.string   "betting_type"
    t.datetime "start_time"
    t.string   "name"
    t.string   "market_type"
    t.integer  "event_id"
    t.string   "status",       default: "OPEN"
  end

  create_table "old_runners", primary_key: "api_id", force: true do |t|
    t.string "name"
  end

  create_table "runners", force: true do |t|
    t.integer "api_id"
    t.integer "exchange_id"
    t.string  "name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: true do |t|
    t.string  "country_code"
    t.string  "name"
    t.string  "territory"
    t.string  "venue_class"
    t.integer "tier"
  end

  add_foreign_key "authorizations", "users", name: "authorizations_user_id_fk"

  add_foreign_key "events", "event_types", name: "events_event_type_id_fk", primary_key: "api_id"
  add_foreign_key "events", "venues", name: "events_venue_id_fk"

  add_foreign_key "market_runners", "markets", name: "market_runners_market_id_fk"
  add_foreign_key "market_runners", "runners", name: "market_runners_runner_id_fk"

  add_foreign_key "markets", "events", name: "markets_event_id_fk", primary_key: "api_id"

  add_foreign_key "old2_market_runners", "markets", name: "market_runners_market_id_fk"
  add_foreign_key "old2_market_runners", "old_runners", name: "market_runners_runner_id_fk", column: "runner_id", primary_key: "api_id"

  add_foreign_key "old_markets", "events", name: "markets_event_id_fk", primary_key: "api_id"

end

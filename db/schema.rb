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

ActiveRecord::Schema.define(version: 20150531081411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actual_aircrafts", force: true do |t|
    t.string  "iata"
    t.string  "fs_iata"
    t.string  "name"
    t.string  "manufacturer"
    t.integer "capacity"
  end

  create_table "actual_configurations", force: true do |t|
    t.string   "carrier"
    t.string   "iata"
    t.string   "name"
    t.json     "config"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actual_fares", force: true do |t|
    t.string  "origin"
    t.string  "destination"
    t.integer "fare"
  end

  create_table "actual_flights", force: true do |t|
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.integer  "duration"
    t.string   "equipment"
    t.string   "carrier"
    t.integer  "flight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "capacity"
    t.string   "iata"
  end

  create_table "actual_routes", force: true do |t|
    t.integer "route_id"
    t.integer "origin_id"
    t.integer "destination_id"
    t.integer "flights"
    t.json    "carriers"
    t.json    "capacity"
    t.json    "fares"
  end

  create_table "aircraft_configurations", force: true do |t|
    t.string   "name"
    t.integer  "aircraft_id"
    t.integer  "airline_id"
    t.integer  "f_count"
    t.integer  "j_count"
    t.integer  "p_count"
    t.integer  "y_count"
    t.integer  "f_seat"
    t.integer  "j_seat"
    t.integer  "p_seat"
    t.integer  "y_seat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aircrafts", force: true do |t|
    t.string   "manufacturer"
    t.string   "name"
    t.string   "iata"
    t.string   "sqft"
    t.string   "capacity"
    t.integer  "price"
    t.integer  "range"
    t.integer  "speed"
    t.integer  "turn_time"
    t.integer  "fuel_capacity"
    t.integer  "fuel_burn"
    t.float    "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "airlines", force: true do |t|
    t.string   "name",       limit: 50, null: false
    t.string   "icao",       limit: 3,  null: false
    t.integer  "money",      limit: 8
    t.integer  "game_id",               null: false
    t.integer  "user_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "airports", force: true do |t|
    t.string   "iata",            limit: 3
    t.string   "icao",            limit: 4
    t.string   "citycode",        limit: 3
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "population"
    t.integer  "slots_total"
    t.integer  "slots_available"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "business_demand"
    t.string   "leisure_demand"
    t.string   "region"
    t.string   "country_code"
    t.integer  "display_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alliance_chats", force: true do |t|
    t.integer  "airline_id"
    t.integer  "alliance_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alliance_memberships", force: true do |t|
    t.integer  "airline_id"
    t.integer  "alliance_id"
    t.boolean  "status",      default: false
    t.integer  "position",    default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alliances", force: true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "balance_sheets", force: true do |t|
    t.integer  "cash_assets"
    t.integer  "fuel_assets"
    t.integer  "current_assets"
    t.integer  "aircraft_assets"
    t.integer  "total_assets"
    t.integer  "long_term_debt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fare_averages", force: true do |t|
  end

  create_table "flights", force: true do |t|
    t.integer  "airline_id"
    t.integer  "route_id"
    t.integer  "user_aircraft_id"
    t.integer  "duration"
    t.integer  "frequencies"
    t.json     "fare"
    t.json     "passengers"
    t.json     "revenue"
    t.json     "load"
    t.integer  "cost"
    t.integer  "profit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_chats", force: true do |t|
    t.integer  "game_id"
    t.integer  "airline_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "region"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "income_statements", force: true do |t|
    t.integer  "total_revenue"
    t.integer  "passenger_revenue"
    t.integer  "cargo_revenue"
    t.integer  "total_cost"
    t.integer  "fuel_cost"
    t.integer  "salaries"
    t.integer  "aircraft_cost"
    t.integer  "special_cost"
    t.integer  "operating_income"
    t.integer  "interest_expense"
    t.integer  "pre_tax_income"
    t.integer  "net_income"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "type_id"
    t.integer  "airline_id"
    t.boolean  "read",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message_type"
  end

  add_index "messages", ["airline_id"], name: "index_messages_on_airline_id", using: :btree
  add_index "messages", ["type_id"], name: "index_messages_on_type_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "flight_id"
    t.integer  "route_id"
    t.string   "text"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", force: true do |t|
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.integer  "distance"
    t.json     "minfare"
    t.json     "maxfare"
    t.json     "price"
    t.json     "demand"
    t.json     "elasticity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seats", force: true do |t|
    t.string   "name"
    t.string   "service_class"
    t.float    "sqft"
    t.integer  "price"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ten_qs", force: true do |t|
    t.integer  "airline_id"
    t.string   "period"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_aircrafts", force: true do |t|
    t.integer  "aircraft_id"
    t.integer  "airline_id"
    t.integer  "aircraft_configuration_id"
    t.integer  "age"
    t.boolean  "inuse"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end

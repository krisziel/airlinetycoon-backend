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

ActiveRecord::Schema.define(version: 20150304000601) do

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
    t.integer  "money",      limit: 8,  null: false
    t.integer  "game_id",               null: false
    t.integer  "user_id",               null: false
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

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end

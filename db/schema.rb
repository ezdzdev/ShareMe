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

ActiveRecord::Schema.define(version: 20141114023751) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "playlist_tracks", force: true do |t|
    t.integer  "playlist_id"
    t.integer  "track_id"
    t.integer  "track_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", force: true do |t|
    t.string   "user_url",   null: false
    t.string   "share_url",  null: false
    t.integer  "views"
    t.integer  "responses"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: true do |t|
    t.string   "track_name", null: false
    t.string   "track_url",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

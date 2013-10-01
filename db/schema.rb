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

ActiveRecord::Schema.define(version: 20131001090513) do

  create_table "measures", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.integer  "time"
    t.integer  "level"
    t.string   "title"
    t.string   "description"
    t.text     "directions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "portion"
  end

  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id"

  create_table "taggings", force: true do |t|
    t.integer  "recipe_id"
    t.integer  "tag_id"
    t.float    "amount"
    t.integer  "measure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.integer  "category"
    t.integer  "father"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "votes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.integer  "vote"
  end

  add_index "votes", ["recipe_id"], name: "index_votes_on_recipe_id"
  add_index "votes", ["user_id", "recipe_id"], name: "index_votes_on_user_id_and_recipe_id", unique: true
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end

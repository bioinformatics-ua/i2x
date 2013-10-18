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

ActiveRecord::Schema.define(version: 20131018153910) do

  create_table "agents", force: true do |t|
    t.string   "type"
    t.text     "options"
    t.text     "memory"
    t.string   "identifier"
    t.string   "title"
    t.text     "help"
    t.string   "schedule"
    t.integer  "events_count"
    t.datetime "last_check_at"
    t.datetime "last_event"
    t.text     "seed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action"
  end

  create_table "bttf", force: true do |t|
    t.timestamp "ts",          null: false
    t.string    "title"
    t.text      "description"
  end

  create_table "stds", force: true do |t|
    t.string   "key"
    t.string   "label"
    t.string   "help"
    t.integer  "visited"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: true do |t|
    t.string   "identifier"
    t.text     "title"
    t.text     "help"
    t.string   "publisher"
    t.text     "variables"
    t.text     "payload"
    t.text     "memory"
    t.integer  "count"
    t.datetime "last_execute_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "username"
    t.string   "apikey"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "variants", force: true do |t|
    t.string   "refseq"
    t.string   "gene"
    t.string   "variant"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

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

ActiveRecord::Schema.define(version: 20140204111437) do

  create_table "agent_mappings", force: true do |t|
    t.integer  "integration_id"
    t.integer  "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agents", force: true do |t|
    t.string   "publisher"
    t.text     "payload"
    t.text     "memory"
    t.string   "identifier"
    t.string   "title"
    t.text     "help"
    t.string   "schedule"
    t.integer  "events_count"
    t.integer  "status",        default: 100
    t.datetime "last_check_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agents", ["identifier"], name: "index_agents_on_identifier", unique: true, using: :btree

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "caches", force: true do |t|
    t.string   "publisher"
    t.integer  "agent_id"
    t.text     "payload"
    t.text     "memory"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seed"
  end

  add_index "caches", ["id"], name: "index_caches_on_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: true do |t|
    t.text     "payload"
    t.text     "memory"
    t.integer  "agent_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integration_mappings", force: true do |t|
    t.integer  "integration_id"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integrations", force: true do |t|
    t.string   "identifier"
    t.string   "title"
    t.text     "help"
    t.text     "payload"
    t.text     "memory"
    t.integer  "status",     default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "integrations", ["identifier"], name: "index_integrations_on_identifier", unique: true, using: :btree

  create_table "seed_mappings", force: true do |t|
    t.integer  "agent_id"
    t.integer  "seed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seeds", force: true do |t|
    t.string   "identifier"
    t.string   "title"
    t.string   "publisher"
    t.text     "help"
    t.text     "payload"
    t.text     "memory"
    t.integer  "status",     default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: true do |t|
    t.string   "identifier"
    t.text     "title"
    t.text     "help"
    t.string   "publisher"
    t.text     "payload"
    t.text     "memory"
    t.integer  "count"
    t.integer  "status",          default: 100
    t.datetime "last_execute_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "templates", ["identifier"], name: "index_templates_on_identifier", unique: true, using: :btree

  create_table "user_agents", force: true do |t|
    t.integer  "user_id"
    t.integer  "agent_id"
    t.integer  "status",     default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_integrations", force: true do |t|
    t.integer  "user_id"
    t.integer  "integration_id"
    t.integer  "status",         default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_templates", force: true do |t|
    t.integer  "user_id"
    t.integer  "template_id"
    t.integer  "status",      default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
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
    t.integer  "status",                 default: 100
    t.string   "image"
    t.string   "location"
    t.text     "referring_url"
    t.text     "landing_url"
    t.text     "meta"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

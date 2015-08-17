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

ActiveRecord::Schema.define(version: 20150813065851) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "entries", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "owner_committed_at"
    t.datetime "paid_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "type"
    t.datetime "expected_at"
    t.datetime "performed_at"
    t.datetime "owner_canceled_at"
    t.datetime "user_canceled_at"
    t.text     "note"
    t.datetime "user_committed_at"
    t.integer  "price",              default: 0
    t.integer  "payment_id"
  end

  add_index "entries", ["payment_id"], name: "index_entries_on_payment_id"
  add_index "entries", ["task_id"], name: "index_entries_on_task_id"
  add_index "entries", ["user_id"], name: "index_entries_on_user_id"

  create_table "messages", force: :cascade do |t|
    t.text     "body",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_id"
    t.integer  "recepient_id"
    t.integer  "entry_id"
    t.string   "type"
  end

  add_index "messages", ["recepient_id"], name: "index_messages_on_recepient_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "body"
    t.string   "url",        default: "#"
    t.datetime "read_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "notifications", ["url"], name: "index_notifications_on_url"
  add_index "notifications", ["user_id", "url"], name: "index_notifications_on_user_id_and_url", unique: true
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "payments", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recepient_id"
    t.string   "subject",                  null: false
    t.integer  "amount",                   null: false
    t.integer  "sender_balance_after",     null: false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_balance_before"
    t.integer  "recepient_balance_before"
    t.integer  "recepient_balance_after"
  end

  add_index "payments", ["recepient_id"], name: "index_payments_on_recepient_id"
  add_index "payments", ["sender_id"], name: "index_payments_on_sender_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "tasks", force: :cascade do |t|
    t.string   "type",        null: false
    t.integer  "user_id"
    t.string   "title",       null: false
    t.integer  "category_id"
    t.text     "description"
    t.string   "price",       null: false
    t.datetime "expired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closed_at"
  end

  add_index "tasks", ["category_id"], name: "index_tasks_on_category_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "users", force: :cascade do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
    t.boolean  "admin"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end

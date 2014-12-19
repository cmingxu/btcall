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

ActiveRecord::Schema.define(version: 20141219143402) do

  create_table "addresses", force: true do |t|
    t.string   "account_name"
    t.integer  "user_id"
    t.string   "btcaddress"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", force: true do |t|
    t.datetime "open_at"
    t.string   "trend"
    t.boolean  "win"
    t.integer  "amount"
    t.integer  "user_id"
    t.string   "status"
    t.integer  "order_price"
    t.integer  "open_price"
    t.integer  "win_reward"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "open_at_code"
  end

  create_table "pages", force: true do |t|
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recharges", force: true do |t|
    t.string   "txid"
    t.string   "status"
    t.string   "btc_address"
    t.integer  "address_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "account"
    t.decimal  "amount_decimal", precision: 10, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickers", force: true do |t|
    t.string   "soure"
    t.integer  "high"
    t.integer  "low"
    t.integer  "buy"
    t.integer  "sell"
    t.integer  "last"
    t.integer  "vol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "last_login_ip"
    t.datetime "last_login_at"
    t.string   "reset_password_token"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_code"
    t.string   "account"
    t.decimal  "btc_balance",          precision: 10, scale: 4
    t.string   "withdraw_address"
  end

  create_table "withdraws", force: true do |t|
    t.decimal  "amount",        precision: 10, scale: 8
    t.string   "to_bc_address"
    t.string   "txid"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "verified_at"
    t.datetime "sent_at"
    t.text     "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

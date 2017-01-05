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

ActiveRecord::Schema.define(version: 20170105214723) do

  create_table "bitpay_webhooks", force: :cascade do |t|
    t.text     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "url"
    t.string   "bitpay_id"
    t.string   "status"
    t.string   "btcPrice"
    t.float    "price"
    t.string   "currency"
    t.string   "invoiceTime"
    t.string   "expirationTime"
    t.string   "currentTime"
    t.string   "btcPaid"
    t.string   "btcDue"
    t.float    "rate"
    t.boolean  "exceptionStatus"
    t.text     "buyerFields"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.integer  "gatekeeper_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.float    "daily_usd_amount"
    t.boolean  "active"
    t.string   "encrypted_mnemonic"
    t.string   "encrypted_mnemonic_iv"
    t.float    "total_donations"
  end

  add_index "clients", ["gatekeeper_id"], name: "index_clients_on_gatekeeper_id"

  create_table "gatekeepers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "txid"
    t.string   "sender"
    t.string   "recipient"
    t.float    "amount"
    t.datetime "time"
    t.integer  "block_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "fee"
    t.string   "currency"
    t.string   "block_hash"
    t.integer  "block_height"
    t.text     "addresses"
    t.integer  "total"
    t.integer  "fees"
    t.integer  "size"
    t.string   "preference"
    t.string   "relayed_by"
    t.datetime "confirmed"
    t.datetime "received"
    t.integer  "confirmations"
    t.text     "inputs"
    t.text     "outputs"
    t.integer  "wallet_id"
  end

  add_index "transactions", ["wallet_id"], name: "index_transactions_on_wallet_id"

  create_table "users", force: :cascade do |t|
    t.integer  "gatekeeper_id"
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["gatekeeper_id"], name: "index_users_on_gatekeeper_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vendors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "encrypted_bitpay_pem"
    t.string   "encrypted_bitpay_pem_iv"
  end

  create_table "wallets", force: :cascade do |t|
    t.string   "address"
    t.integer  "balance"
    t.boolean  "active"
    t.integer  "transactor_id"
    t.string   "transactor_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "currency"
    t.boolean  "primary"
    t.integer  "total_received"
    t.integer  "total_sent"
    t.integer  "unconfirmed_balance"
    t.integer  "final_balance"
    t.integer  "n_tx"
    t.integer  "unconfirmed_n_tx"
    t.integer  "final_n_tx"
    t.string   "wallet_type"
    t.integer  "hd_position"
    t.integer  "last_block_height"
    t.text     "txs"
  end

  add_index "wallets", ["transactor_type", "transactor_id"], name: "index_wallets_on_transactor_type_and_transactor_id"

end

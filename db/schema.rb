# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_18_122231) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "login"
    t.string "password"
    t.string "server"
    t.string "name"
    t.string "company"
    t.string "currency"
    t.integer "leverage"
    t.integer "stopout_level"
    t.integer "stopout_mode"
    t.float "balance"
    t.float "credit"
    t.float "equity"
    t.float "margin"
    t.float "free_margin"
    t.bigint "test_pass_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["test_pass_id"], name: "index_accounts_on_test_pass_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.string "symbol"
    t.integer "kind"
    t.datetime "open_date", precision: nil
    t.datetime "close_date", precision: nil
    t.float "lot_size"
    t.float "open_price_cents"
    t.string "open_price_currency"
    t.float "close_price_cents"
    t.string "close_price_currency"
    t.float "stop_loss_cents"
    t.string "stop_loass_currency"
    t.float "take_profit_cents"
    t.string "take_profit_currency"
    t.integer "slippage"
    t.text "comment"
    t.string "magic_number"
    t.datetime "expiration", precision: nil
    t.float "profit_cents"
    t.string "profit_currency"
    t.float "swap_cents"
    t.string "swap_currency"
    t.float "commission_cents"
    t.string "commission_currency"
    t.bigint "account_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "test", default: false
    t.index ["account_id"], name: "index_orders_on_account_id"
  end

  create_table "specifications", force: :cascade do |t|
    t.string "symbol", null: false
    t.integer "precision"
    t.integer "stoploss_level"
    t.integer "lot_size"
    t.string "margin_currency", default: "USD", null: false
    t.string "orders_currency"
    t.integer "leverage"
    t.float "minimum_lot_size"
    t.float "maximum_lot_size"
    t.float "lot_size_step"
    t.float "short_swap"
    t.float "long_swap"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["symbol"], name: "index_specifications_on_symbol"
  end

  create_table "test_passes", force: :cascade do |t|
    t.string "symbol"
    t.integer "timeframe"
    t.datetime "start_date", precision: nil
    t.datetime "stop_date", precision: nil
    t.string "strategy"
    t.integer "bars_processed"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end

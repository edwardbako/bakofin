# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_13_073500) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_pass_id"], name: "index_accounts_on_test_pass_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "symbol"
    t.integer "kind"
    t.datetime "open_date"
    t.datetime "close_date"
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
    t.datetime "expiration"
    t.float "profit_cents"
    t.string "profit_currency"
    t.float "swap_cents"
    t.string "swap_currency"
    t.float "commission_cents"
    t.string "commission_currency"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_specifications_on_symbol"
  end

  create_table "test_passes", force: :cascade do |t|
    t.string "symbol"
    t.integer "timeframe"
    t.datetime "start_date"
    t.datetime "stop_date"
    t.string "strategy"
    t.integer "bars_processed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

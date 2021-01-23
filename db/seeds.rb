# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Specification.create(
  symbol: :XAUUSD,
  precision: 2,
  stoploss_level: 100,
  lot_size: 100,
  margin_currency: "USD",
  orders_currency: "USD",
  leverage: 200,
  minimum_lot_size: 0.01,
  maximum_lot_size: 10000.0,
  lot_size_step: 0.01,
  short_swap: -1.846,
  long_swap: -4.61
)

Specification.create(
  symbol: :EURUSD,
  precision: 5,
  stoploss_level: 30,
  lot_size: 100000,
  margin_currency: "EUR",
  orders_currency: "USD",
  leverage: 500,
  minimum_lot_size: 0.01,
  maximum_lot_size: 10000.0,
  lot_size_step: 0.01,
  short_swap: 1.367,
  long_swap: -8.813
)

Specification.create(
  symbol: :USDRUB,
  precision: 4,
  stoploss_level: 50,
  lot_size: 100000,
  margin_currency: "USD",
  orders_currency: "RUB",
  leverage: 250,
  minimum_lot_size: 0.01,
  maximum_lot_size: 10000.0,
  lot_size_step: 0.01,
  short_swap: -31.848,
  long_swap: -186.034
)

Specification.create(
  symbol: :USDCHF,
  precision: 5,
  stoploss_level: 30,
  lot_size: 100000,
  margin_currency: "USD",
  orders_currency: "CHF",
  leverage: 200,
  minimum_lot_size: 0.01,
  maximum_lot_size: 10000.0,
  lot_size_step: 0.01,
  short_swap: -3.855,
  long_swap: 0.416
)

Specification.create(
  symbol: :BTCUSD,
  precision: 3,
  stop_loss_level: 0,
  lot_size: 1,
  margin_currency: "USD",
  orders_currency: "USD",
  leverage: 100,
  minimum_lot_size: 0.01,
  maximum_lot_size: 15.0,
  lot_size_step: 0.01,
  short_swap: 1292.267,
  long_swap: -14212.12
)
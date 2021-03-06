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
                leverage: 500,
                minimum_lot_size: 0.01,
                maximum_lot_size: 10000.0,
                lot_size_step: 0.01,
                short_swap: 1.367,
                long_swap: -8.813
)
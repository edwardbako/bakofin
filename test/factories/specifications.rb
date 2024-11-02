FactoryBot.define do
  factory :specification do
    symbol { :XAUUSD }
    precision { 2 }
    stoploss_level { 100 }
    lot_size { 100 }
    margin_currency { "USD" }
    orders_currency { "USD" }
    leverage { 200 }
    minimum_lot_size { 0.01 }
    maximum_lot_size { 10000.0 }
    lot_size_step { 0.01 }
    short_swap { -1.846 }
    long_swap { -4.61 }

    factory :test_specification do
      test { true }
    end

    factory :specification_with_fake_symbol do
      symbol { :FKFLDD }
    end
  end
end

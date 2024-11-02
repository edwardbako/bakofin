FactoryBot.define do
  factory :series do
    symbol { "XAUUSD" }
    timeframe { 60 }
    test { true }

    initialize_with { new(symbol: symbol, timeframe: timeframe, test: test) }

    factory :blank_series do
      symbol { nil }
      timeframe { nil }
    end
  end
end

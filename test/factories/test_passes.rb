FactoryBot.define do
  factory :test_pass do
    symbol { :XAUUSD }
    timeframe { 1 }
    start_date { "2014-10-04 00:36:33" }
    stop_date { "2024-10-04 00:36:33" }
    strategy { Strategy::Bands }

    initialize_with { new(symbol: symbol, timeframe: timeframe, strategy: strategy) }
  end
end

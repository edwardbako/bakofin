class StrategyTester

  attr_accessor :quotes, :strategy, :symbol, :timeframe, :start_date, :stop_date

  def initialize(strategy: nil, symbol: nil, timeframe: 1,
                 start_date: Time.now - 10.years, stop_date: Time.now)
    @strategy = strategy
    @symbol = symbol
    @timeframe = timeframe
    @start_date = start_date
    @stop_date = stop_date
  end

  def run
    quotes.each do |quote|

    end
  end

  Struct.new("Quote", :open, :high, :low, :close, :volume, :symbol, :timeframe) do

  end

  private

  def quotes
    # TODO
  end
end
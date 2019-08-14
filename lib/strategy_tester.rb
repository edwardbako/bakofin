require 'highline/import'
# == Strategy Tester
#
# The main task of strategy tester is to simulate ticks appearance of given time series.
#
# Create a new tester instance and run it.
#
#   tester = StrategyTester.new strategy_class: Strategy::MACross, symbol: :XAUUSD, timeframe: 60
#   tester.run # => true
#   tester.report
#
# This will produce a report on last run.
class StrategyTester
  # include Concurrent::Async

  attr_accessor :strategy_class, :symbol, :timeframe, :start_date, :stop_date
  attr_reader :series, :strategy

  def initialize(**args)
    args = defaults.merge args
    @symbol = args[:symbol]
    @timeframe = args[:timeframe]
    @strategy_class = args[:strategy_class]
    @series = strategy.series
    @start_date = args[:start_date]
    @stop_date = args[:stop_date]
    @action = nil
  end

  def defaults
    {strategy_class: nil, symbol: nil, timeframe: nil,
      start_date: Time.now - 10.years, stop_date: Time.now}
  end

  def run
    loader.load_to_redis do |i, size|
      trade(i, size)
      # sleep 3
    end
    pass.save
  end

  def log
  end

  def report
    pass.report
  end

  private

  def trade(i, size)
    trader.trade signal: strategy.signal
    # print "#{i} quotes processed. \r"
    pass.bars_processed = i
    trader.close_all_orders if i == size
  end

  def series
    @series ||= ::Series.new symbol: symbol, timeframe: timeframe, test: true
  end

  def strategy
    @strategy ||= strategy_class.new series: series
  end

  def pass
    @pass ||= TestPass.create symbol: symbol,
                           timeframe: timeframe,
                           start_date: start_date,
                           stop_date: stop_date,
                           strategy: strategy
  end

  def account
    @account ||= pass.account
  end

  def loader
    # TODO: Get rid of parameters?
    @loader ||= QuotesLoader.new symbol: symbol, timeframe: timeframe, test: true
  end

  def trader
    @trader ||= Trader.new series: series, account: account
  end

end
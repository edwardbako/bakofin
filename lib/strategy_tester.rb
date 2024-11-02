require "highline/import"
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
  include Loggable

  attr_accessor :strategy_class, :symbol, :timeframe, :start_date, :stop_date

  # OPTIMIZE: Implement creation with Builder pattern
  # TODO: Make Specification somewhat globally available
  def initialize(**args)
    args = defaults.merge args
    @symbol = args[:symbol]
    @timeframe = args[:timeframe]
    @strategy_class = "Strategy::#{args[:strategy]}".constantize
    @series = strategy.series
    @start_date = args[:start_date]
    @stop_date = args[:stop_date]
    @action = nil
  end

  def defaults
    {
      strategy: :Bands,
      symbol: :XAUUSD,
      timeframe: 60,
      start_date: Time.now - 10.years,
      stop_date: Time.now }
  end

  def run
    start = Time.now
    logger.info(prog_name) { "Test Pass #{pass.id} starting..." }

    loader.load_to_redis do |i, size|
      if account.equity < 0
        trader.close_all_orders
        logger.fatal(prog_name) { "Account is out of money. Strategy parameters are BULLSHIT." }
        break
      end

      trade(i, size)
    end
    pass.save

    duration = (Time.now - start) % 1.day
    logger.info(prog_name) { "Test Pass #{pass.id} stopped. It took #{duration.inspect} to run test." }
    logger.close
  end

  delegate :report, to: :pass

  def series
    @series ||= ::Series.new symbol:, timeframe:, test: true, logger:
  end

  def strategy
    @strategy ||= strategy_class.new(series:, logger:)
  end

  def pass
    @pass ||= TestPass.create symbol:,
                              logger:,
                              timeframe:,
                              start_date:,
                              stop_date:,
                              strategy: strategy_class
  end

  def account
    @account ||= pass.account
  end

  def loader
    # TODO: Get rid of parameters?
    # TODO: Set :test attribute some kind globally. That is no need to pass it through.
    @loader ||= QuotesLoader.new symbol:, timeframe:, test: true, logger:
  end

  def trader
    @trader ||= Trader.new series:, account:, test: true, logger:
  end

  private

  def trade(i, size)
    trader.trade signal: strategy.signal
    logger.debug(prog_name) { "Opened / Total orders: #{account.orders.opened.count} / #{account.orders.count}" }
    logger.debug(prog_name) { "Current account balance is #{account.balance}" }
    logger.debug(prog_name) { "Current account equity is #{account.equity}" }
    logger.debug(prog_name) { "Current account margin is #{account.margin}" }

    pass.update(bars_processed: i)
    trader.close_all_orders if i == size
  end
end

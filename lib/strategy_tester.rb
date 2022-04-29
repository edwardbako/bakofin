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
  include Loggable

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

    logger.info(prog_name) { "Test Pass #{pass.id} stop."}
  end

  def report
    pass.report
  end

  def logger
    @logger ||= Logger.new(File.join(Rails.root,"log/strategy_tester/#{Time.now.xmlschema}.log"))
  end

  def self.clear_logs
    FileUtils.rm_rf(File.join(Rails.root, "log/strategy_tester/."))
  end


  def series
    @series ||= ::Series.new symbol: symbol, timeframe: timeframe, test: true, logger: logger
  end

  def strategy
    @strategy ||= strategy_class.new(series: series, logger: logger)
  end

  def pass
    @pass ||= TestPass.create symbol: symbol,
    logger: logger,
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
    @loader ||= QuotesLoader.new symbol: symbol, timeframe: timeframe, test: true, logger: logger
  end

  def trader
    @trader ||= Trader.new series: series, account: account, test: true, logger: logger
  end

  private

  def trade(i, size)
    trader.trade signal: strategy.signal
    logger.debug(prog_name) { "Opened / Total orders: #{account.orders.opened.count} / #{account.orders.count}" }
    logger.debug(prog_name) { "Current account balance is #{account.balance}" }
    logger.debug(prog_name) { "Current account equity is #{account.equity}" }
    logger.debug(prog_name) { "Current account margin is #{account.margin}" }

    # print "#{i} quotes processed. \r"
    pass.bars_processed = i
    trader.close_all_orders if i == size
  end

end

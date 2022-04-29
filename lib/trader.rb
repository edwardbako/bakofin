# == Trader
#
# Performs trading operations on given symbol. It calculates lot size, opens and closes orders
# at given rate.
class Trader
  include Loggable

  attr_accessor :series, :account, :magic_number, :max_load_percent, :risk_per_trade_percent, :max_opened_orders, :test

  def initialize(**args)
    args.reverse_merge! defaults
    args.each do |key, value|
      instance_variable_set "@#{key}", value
    end

  end

  def defaults
    {
      series: nil,
      account: nil,
      magic_number: SecureRandom.uuid,
      max_load_percent: 0.1,
      risk_per_trade_percent: 0.02,
      decrease_factor: 5.0,
      max_opened_orders: 2
    }
  end

  def trade(signal: :none)
    send signal
  end

  def close_all_orders
    logger.debug(prog_name) { "Closing all orders." }
    close_buy
    close_sell
  end

  private

  def open_buy
    logger.debug(prog_name) { "OPEN BUY signal received."}
    logger.debug(prog_name) { "Trying to close short orders."}
    close_sell
    open_order kind: :buy
  end

  def open_sell
    logger.debug(prog_name) { "OPEN SELL signall received."}
    logger.debug(prog_name) { "Trying to close long orders."}
    close_buy
    open_order kind: :sell
  end

  def close_buy
    logger.debug(prog_name) { "CLOSE BUY signal received."}
    close_orders kind: :buy
  end

  def close_sell
    logger.debug(prog_name) { "CLOSE SELL signal received."}
    close_orders kind: :sell
  end

  def none
    logger.debug(prog_name) { "Nothing to do." }
    nil
  end

  def open_order(kind: nil)
    lot = lot_size(kind)
    if lot > 0 and orders.opened.count < max_opened_orders
      logger.debug(prog_name) { "Trying to open new order..."}
      order = orders.create symbol: series.symbol,
                    kind: kind,
                    lot_size: lot,
                    open_date: series[0].time,
                    open_price: specification.open_price_by_kind(kind),
                    close_price: specification.close_price_by_kind(kind),
                    stop_loss: stop_loss(kind),
                    take_profit: 0,
                    profit: 0,
                    swap: 0,
                    commission: 0,
                    magic_number: magic_number,
                    logger: logger,
                    test: test
      logger.debug(prog_name) { "New order created: #{order.attributes}"}
    end
  end

  def close_orders(kind: nil)
    orders.send(kind).opened.each do |o|
      o.close price: specification.close_price_by_kind(kind), date: series[0].time
      logger.debug(prog_name) { "Order has been closed. #{o.inspect}"}
    end
  end

  def orders
    account.orders.where(magic_number: magic_number)
  end

  def lot_by_margin(kind)
    specification.lot_by_margin(free_margin * account.leverage, kind)
  end

  def lot_by_risk
    specification.lot_by_risk(risk_per_trade)
  end

  def lot_size(kind)
    lbm, lbr = lot_by_margin(kind), lot_by_risk
    logger.debug(prog_name) { "Lot by margin is #{lbm}"}
    logger.debug(prog_name) { "Lot by risk is #{lbr}"}
    [lbm, lbr].min
  end

  def max_load
    account.equity * max_load_percent
  end

  def free_margin
    max_load - margin
  end

  def risk_per_trade
    account.equity * risk_per_trade_percent
  end

  def margin
    orders.opened.sum(&:margin)
  end

  def load
    margin / account.equity.to_f
  end

  def specification
    @specification ||= series.specification
  end

  def stop_loss(kind)
    sl = specification.point * specification.stoploss_level

    case kind
    when :buy
      -sl
    when :sell
      sl
    end + specification.close_price_by_kind(kind)
  end
end
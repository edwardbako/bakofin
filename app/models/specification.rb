# == Specification
#
# This is a place to store specifications on trading currencies.
#
# We need information about:
#   * Symbol
#   * Precision
#   * Stop-loss levels
#   * Contract / Lot size
#   * Margin currency
#   * leverage
#   * Minimum lot size
#   * Maximum lot size
#   * Lot size step
#   * Short positions swap
#   * Long positions swap

class Specification < ApplicationRecord

  class Error < StandardError; end
  class NoDataError < Error; end

  def pips(lot)
    (lot_size * lot * point) / rate_for_base
  end

  def point
    10**(-precision).to_f
  end

  def ask
    get(:ask).to_f
  end

  def bid
    get(:bid).to_f
  end

  def spread
    ((ask - bid) * 100).to_i
  end

  def market_prices
    {
      bid: bid,
      ask: ask,
      spread: spread
    }
  end

  def stoploss_cost(lot)
    pips(lot) * stoploss_level
  end

  def lot_by_risk(amount)
    lot = (amount * rate_for_base) / (stoploss_level * point * lot_size)
    lot.round(lot_size_step_digits)
  end

  def lot_by_margin(margin, kind)
    lot = margin / (lot_size * open_price_by_kind(kind))
    lot.round(lot_size_step_digits)
  end

  def open_price_by_kind(kind)
    case kind
    when :buy
      ask
    when :sell
      bid
    else
      ask
    end
  end

  def close_price_by_kind(kind)
    case kind
    when :buy
      bid
    when :sell
      ask
    else
      bid
    end
  end

  private

  def get(key)
    response = $redis.get("#{symbol}:#{key}")
    raise NoDataError, "There is no market data for :#{symbol} symbol." if response.blank?
    response
  end

  def rate_for_base
    if orders_currency == "USD"
      1
    else
      specification_for_base(orders_currency).ask
    end
  end

  def specification_for_base(base)
    sym = "USD#{base}"
    specification = Specification.find_by(symbol: sym)

    if specification.present?
      specification
    else
      raise NoDataError, "There is no specification for :#{sym} symbol."
    end
  end

  def lot_size_step_digits
    lot_size_step.to_s.split('.')[1].size
  end

end

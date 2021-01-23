# == Order
#
# Main model to store deals information.
# Order attributes:
#   * Id
#   * Symbol
#   * Type
#   * Open Date
#   * Lot size
#   * Open Price
#   * Close price
#   * Close Date
#   * Stop Loss
#   * Take Profit
#   * Slippage
#   * Comment
#   * Magic number
#   * Expiration
class Order < ApplicationRecord


  enum kind: [:buy, :sell, :buy_limit, :sell_limit, :buy_stop, :sell_stop, :balance]

  monetize :open_price_cents,
           :close_price_cents,
           :stop_loss_cents,
           :take_profit_cents,
           :profit_cents,
           :swap_cents,
           :commission_cents

  belongs_to :account

  scope :opened, -> { where(close_date: nil) }
  scope :closed, -> { where.not(close_date: nil)}

  def opened?
    close_date.blank?
  end

  def closed?
    close_date.present?
  end

  def close(price: nil, date: nil)
    self.close_price = price
    self.close_date = date
    save
  end

  def profit
    if close_price.present?
      Money.add_rate(prices_currency, account_currency, 1 / close_price.to_f) if prices_currency != account_currency

      case kind
      when "buy", "buy_limit", "buy_stop"
        (close_price - open_price) * base_lot_size * lot_size
      when "sell", "sell_limit", "sell_stop"
        (open_price - close_price) * base_lot_size * lot_size
      when "balance"
        close_price
      end.exchange_to(account_currency).round
    end
  end

  def retention_time
    if closed?
      ((close_date - open_date) / 60 / 60 / 24.0).round(2).days
    end
  end

  def margin
    Money.add_rate(prices_currency, account_currency, 1 / open_price.to_f ) if prices_currency != account_currency
    (lot_size * base_lot_size * open_price / account.leverage.to_f).exchange_to(account_currency).round
  end

  def prices_currency
    if specification.present?
      specification.orders_currency
    else
      :USD
    end
  end

  def reward_to_risk_ratio
    profit / specification.stoploss_cost(lot_size)
  end

  private

  def specification
    @specification ||= Specification.find_by(symbol: symbol)
  end

  def base_lot_size
    @base_lot_size ||= specification.lot_size
  end

  def account_currency
    @account_currency ||= account.currency
  end

end
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
  include Loggable

  def initialize(attributes = {})
    super
    @logger = attributes[:logger]
  end

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
    current_close_price = closed? ? close_price : Money.new(specification.close_price_by_kind(kind) * 100, prices_currency)
    Money.add_rate(prices_currency, account_currency, 1 / current_close_price.to_f) if prices_currency.to_sym != account_currency.to_sym

    case kind
    when "buy", "buy_limit", "buy_stop"
      (current_close_price - open_price) * base_lot_size * lot_size
    when "sell", "sell_limit", "sell_stop"
      (open_price - current_close_price) * base_lot_size * lot_size
    when "balance"
      current_close_price
    end.exchange_to(account_currency).round
  end

  def retention_time
    if closed?
      ((close_date - open_date) / 60 / 60 / 24.0).round(2).days
    end
  end

  def margin
    Money.add_rate(prices_currency, account_currency, 1 / open_price.to_f ) if prices_currency.to_sym != account_currency.to_sym
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
    @specification ||= begin
                         sp = Specification.find_by(symbol: symbol)
                         sp.test = test if sp.present?
                         sp
                       end
  end

  def base_lot_size
    @base_lot_size ||= specification.lot_size
  end

  def account_currency
    @account_currency ||= account.present? ? account.currency : :USD
  end

end
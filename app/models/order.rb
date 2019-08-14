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


  enum kind: [:buy, :sell, :balance]

  monetize :open_price_cents, :close_price_cents, :stop_loss_cents, :take_profit_cents

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
    if opened?
      nil
    else
      case kind
      when "buy"
        (close_price - open_price) * base_lot_size * lot_size
      when "sell"
        (open_price - close_price) * base_lot_size * lot_size
      when "balance"
        close_price
      end
    end
  end

  private

  def specification
    @specification ||= Specification.where(symbol: symbol).first
  end

  def base_lot_size
    @base_lot_size ||= specification.lot_size
  end

end
# == Trader
#
# Performs trading operations on given symbol. It calculates lot size, opens and closes orders
# at given rate.
class Trader

  attr_accessor :series, :account

  def initialize(series: nil, account: nil)
    @series  = series
    @account = account
  end

  def trade(signal: :none)
    send signal
  end

  def close_all_orders
    close_buy
    close_sell
  end

  private

    def open_buy
      close_sell
      open_order kind: :buy
    end

    def open_sell
      close_buy
      open_order kind: :sell
    end

    def close_buy
      close_orders kind: :buy
    end

    def close_sell
      close_orders kind: :sell
    end

    def none
      nil
    end

    def open_order(kind: nil)
      Order.create symbol:     series.symbol,
                   kind:       kind,
                   open_date:  series[0].time,
                   lot_size:   lot_size,
                   open_price: series[0].close,
                   account:  account
    end

    def close_orders(kind: nil)
      account.orders.send(kind).opened.each do |o|
        o.close price: series[0].close, date: series[0].time
      end
    end

    def lot_size
      1
    end

end
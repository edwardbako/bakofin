# == Moving Average technical indicator
#
# Accepts Arguments
#   * series
#   * period
#   * method
#   * price
#
# Supported methods:
#   :sma - Simple Moving Average
#   :ema - Exponential Moving Average
#   :smma - Smoothed Moving Average
#   :lwma - Linear-Weighted Moving Average
#

class Indicator::Ma < Indicator

  attr_reader :method, :price

  class IncorrectMethodError < Indicator::Error
    def message
      super + "Incorrect method."
    end
  end

  private

  def post_initialize(**args)
    raise IncorrectMethodError, "Don't know how to calculate :#{method} method. " unless self.respond_to?(method, true)
  end

  def calculations
    send(method)
  end

  def local_defaults
    {period: 20,
     method: :sma,
     price: :typical}
  end

  def sma
    i = start
    sum = 0
    line = new_line

    # TODO Try to implement whith each method on series.
    while i >= stop
      sum += value(i)

      if i < size + stop
        sum -= value(i + period)
        result = sum / period

        line << bar(i, result)
      end

      i -= 1
    end

    # puts [start, stop, size]
    line.reverse!
  end

  def ema
    i = start
    sum = 0
    line = new_line
    p = 2 / (period + 1).to_f
    prev = 0

    while i >= stop
      q = value(i)

      if i >= size + stop
        sum += q
        prev = sum / period
      else
        result = q * p + prev * (1 - p)

        line << bar(i, result)
        prev = line.first.main
      end

      i -= 1
    end

    line.reverse!
  end

  def smma
    i = start
    sum = 0
    line = new_line

    while i >= stop
      q = value(i)
      if i >= size + stop
        sum += q
        prev = sum / period
      else
        result = (prev * (period - 1) + q) / period

        line << bar(i, result)
        prev = line.first.main
      end

      i -= 1
    end

    line.reverse!
  end

  def lwma
    i = size + stop - 1
    line = new_line
    wsum = (period + 1) * period / 2

    while i >= stop
      sum = 0
      period.times do |j|
        sum += value(i + j) * (period - j)
      end
      result = sum / wsum

      line << bar(i, result)

      i -= 1
    end

    line.reverse!
  end

  def value(index)
    q = series[index]

    unless q.respond_to?(price)
      raise Indicator::IncorrectPriceError
    end

    q.send price
  end

  def bar(index, value)
    new_bar(time: series[index-shift].time,
            main: value.round(digits)
    )
  end

end
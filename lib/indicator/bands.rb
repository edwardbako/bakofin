require 'matrix'
# == Bollinger bands technical indicator
#
# Accepts arguments
#   * series
#   * period
#   * deviation
#   * ma_method
#   * price
#
class Indicator::Bands < Indicator

  attr_reader :deviations, :ma_method, :price

  class IncorrectMethodError < Indicator::Error
    def message
      super + "Incorrect method."
    end
  end

  private

  def local_defaults
    {
        period: 20,
        deviations: 2.0,
        ma_method: :sma,
        price: :typical
    }
  end

  def calculations
    i = start
    line = new_line

    while i >= stop
      if i < size + stop
        middle = ma[i].main
        dev = deviation(i)
        up = upper(middle, dev)
        low = lower(middle, dev)
        p_b = percent_b(i, up, low)

        line << bar(i, middle, up, low, dev, p_b)
      end

      i -= 1
    end

    line.reverse!
  end

  def bar(index, middle, up, low, dev, p_b)
    new_bar(
        time: series[index - shift].time,
        middle: middle,
        upper: up,
        lower: low,
        deviation: dev,
        percent_b: p_b
    )
  end

  def ma
    @ma ||= Indicator::Ma.new(series: series, period: period, shift: shift, method: ma_method, price:  price)
  end

  def deviation(index)
    sum = 0
    main = ma[index].main
    period.times do |j|
      sum += (value(index + j) - main) ** 2
    end
    Math.sqrt(sum / (period - 1)).round(digits)
  end

  def value(index)
    q = series[index]

    unless q.respond_to?(price)
      raise Indicator::IncorrectPriceError
    end

    q.send price
  end

  def upper(middle, dev)
    (middle + deviations * dev).round(digits)
  end

  def lower(middle, dev)
    (middle - deviations * dev).round(digits)
  end

  def percent_b(index, up, low)
    ((value(index) - low) / (up - low) * 100).round(digits)
  end


end
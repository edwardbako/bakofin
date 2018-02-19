# Moving Average technical indicator
class Indicator::MA

  attr_reader :series, :period, :shift, :method, :price, :size

  def initialize(series: nil, period: 20, shift: 0, method: :sma, price: :typical)
    raise Indicator::BlankSeriesError if series.blank?
    @series = series
    @period = period
    @shift = shift
    @method = method
    @price = price
  end

  def [](index)
    @series_to_calculate = series_to_calculate(index)
    @size = @series_to_calculate.size
    send(method)
  end

  private

  def sma
    sum = 0
    result = []

    @series_to_calculate.each_with_index do |q, i|
      sum += q.send(price)
      sum -= @series_to_calculate[i - period].send(price) if i >= period
      if i >= period and i + shift < @size
        result << [@series_to_calculate[i+shift].x,
                   (sum / (i >= period ? period : i+1)).round(digits)]
      end
    end
    result
  end

  def ema
    sum = 0
    result = []
    p = 2 / (period + 1).to_f

    @series_to_calculate.each_with_index do |q, i|
      sum += q.send(price) if i < period
      prev = result.present? ? result.last[1] : sum / period
      if i >= period and i + shift < @size
        result << [@series_to_calculate[i+shift].x,
                   ((q.send(price) - prev) *  p + prev).round(digits)]
      end
    end
    result
  end

  def smma
    sum = 0
    result = []

    @series_to_calculate.each_with_index do |q, i|
      sum += q.send(price) if i < period
      prev = result.present? ? result.last[1] : sum / period
      if i >= period and i + shift < @size
        result << [@series_to_calculate[i+shift].x,
                   ((prev * (period - 1) + q.send(price)) / period).round(digits)]
      end
    end
    result
  end

  def lwma
    result = []
    wsum = (period + 1) * period / 2

    @series_to_calculate.each_with_index do |q, i|
      if i >= period and i + shift < @size
        sum = 0
        period.times do |j|
          sum += @series_to_calculate[i - j].send(price) * (period - j)
        end
        result << [@series_to_calculate[i+shift].x,
                   (sum/wsum).round(digits)]
      end
    end
    result
  end

  def digits
    @digits ||= series.digits
  end

  def series_to_calculate(index)
    start = index.is_a?(Range) ? index.first : index
    stop = index.is_a?(Range) ? index.last + period : index + period
    series[start..stop].reverse
  end

end
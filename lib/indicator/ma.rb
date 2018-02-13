# Moving Average technical indicator
class Indicator::MA

  attr_reader :series, :period, :shift, :method, :price, :size

  def initialize(series: nil, period: 20, shift: 0, method: :sma, price: :typical)
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
      sum += applied_price(q)
      sum -= applied_price(@series_to_calculate[i - period]) if i >= period
      if i >= period and i + shift < @size
        result << [@series_to_calculate[i+shift][:time].to_i * 1000,
                   (sum / (i >= period ? period : i+1)).round(2)]
      end
    end
    result
  end

  def ema
    sum = 0
    result = []
    p = 2 / (period + 1).to_f

    @series_to_calculate.each_with_index do |q, i|
      sum += applied_price(q) if i < period
      prev = result.present? ? result.last[1] : sum / period
      if i >= period and i + shift < @size
        result << [@series_to_calculate[i+shift][:time].to_i * 1000,
                   ((applied_price(q) - prev) *  p + prev).round(2)]
      end
    end
    result
  end

  def smma
    sum = 0
    result = []

    @series_to_calculate.each_with_index do |q, i|
      sum += applied_price(q) if i < period
      prev = result.present? ? result.last[1] : sum / period
      if i >= period and i + shift < @size
        result << [@series_to_calculate[i+shift][:time].to_i * 1000,
                   ((prev * (period - 1) + applied_price(q)) / period).round(2)]
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
          sum += applied_price(@series_to_calculate[i - j]) * (period - j)
        end
        result << [@series_to_calculate[i+shift][:time].to_i * 1000,
                   (sum/wsum).round(2)]
      end
    end
    result
  end

  def series_to_calculate(index)
    start = index.is_a?(Range) ? index.first : index
    stop = index.is_a?(Range) ? index.last + period : index + period
    @series[start..stop].reverse
  end

  def applied_price(rate)
    case price
      when :open
        rate[:open]
      when :high
        rate[:high]
      when :low
        rate[:low]
      when :medial # HL/2
        (rate[:high] + rate[:low]) / 2
      when :typical # HLC/3
        (rate[:high] + rate[:low] + rate[:close]) / 3
      when :weighted # HLCC/4
        (rate[:high] + rate[:low] + 2*rate[:close] ) / 4
      else
        rate[:close]
    end
  end

end
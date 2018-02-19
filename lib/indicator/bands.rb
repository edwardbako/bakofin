require 'matrix'
# Bollinger bands technical indicator
class Indicator::Bands

  attr_reader :series, :period, :deviation, :shift, :ma_method, :price, :size
  # attr_accessor :index

  def initialize(series: nil, period: 20, deviation: 2.0, shift: 0, ma_method: :sma, price: :typical)
    raise Indicator::BlankSeriesError if series.blank?
    @series = series
    @period = period
    @deviation = deviation
    @shift = shift
    @ma_method = ma_method
    @price = price
  end
  
  def [](index)
    @index = index
    @series_to_calculate = series_to_calculate(index)
    times.zip(middle_line, top_line, bottom_line)
  end

  def percent_b(index)
    bb_enum = self[index].each
    s_enum = @series[index].reverse.each
    result = []
    loop do
      bb = bb_enum.next
      result << (applied_price(s_enum.next) - bb[3]) / (bb[2] - bb[3]) * 100
    end
    result
  end

  private

  def middle_line
    @middle_line ||= Indicator::MA.new(series: series, period: period, shift: shift, method: ma_method,
           price: price)[@index].map { |ma| ma[1]}
  end

  def top_line
    @top_line = []
    ml_enum = @middle_line.each
    dev_enum = deviations.each
    loop do
      @top_line << (ml_enum.next + deviation * dev_enum.next).round(2)
    end
    @top_line
  end

  def bottom_line
    @bottom_line = []
    ml_enum = @middle_line.each
    dev_enum = deviations.each
    loop do
      @bottom_line << (ml_enum.next - deviation * dev_enum.next).round(2)
    end
    @bottom_line
  end

  def deviations
    if @deviations.blank?
      @deviations = []
      @series_to_calculate.each_with_index do |q, i|
        if i >= period
          sum = 0
          period.times do |j|
            sum += (@series_to_calculate[i - j].send(price) - middle_line[i-period])**2
          end
          @deviations << Math.sqrt(sum / period)
        end
      end
    end
    @deviations
  end

  def times
    @series_to_calculate.select.with_index { |q, i| i >= period }.map { |q| q.x }
  end

  def series_to_calculate(index)
    start = index.is_a?(Range) ? index.first : index
    stop = index.is_a?(Range) ? index.last + period : index + period
    series[start..stop].reverse
  end

end
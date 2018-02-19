# Money Flow Index technical indicator
class Indicator::MFI

  attr_reader :series, :period

  def initialize(series: nil, period: 14)
    raise Indicator::BlankSeriesError if series.blank?
    @series = series
    @period = period
  end

  def [](index)
    money_ratio(index).map {|mr| 100 - (100 / (1 + mr))}
  end

  private

  def money_flow(range)
    @money_flow ||= begin
      prev = nil
      series_to_calculate(range).map do |q|
        if prev.present?
          mf = q.typical * q.volume * (q.typical >= prev ? 1 : -1)
        end
        prev = q.typical
        mf
      end
    end
  end

  def money_ratio(range)
    if @money_ratio.blank?
      @money_ratio = []
      series_to_calculate(range).each_with_index do |q, i|
        if i >= period
          pmf = 0
          nmf = 0
          period.times do |j|
            mf = money_flow(range)[i-j]
            mf > 0 ? pmf += mf : nmf += mf
          end
          @money_ratio << pmf / nmf.abs
        end
      end
    end
    @money_ratio
  end

  def price(rate)
    (rate[:high] + rate[:low] + rate[:close]) / 3
  end

  def series_to_calculate(index)
    @series_to_calculate ||= begin
      start = index.is_a?(Range) ? index.first : index
      stop = index.is_a?(Range) ? index.last + period : index + period
      series[start..stop].reverse
    end
  end
end
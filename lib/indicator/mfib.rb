# Percent B of Money Flow Index technical indicator
#
# Accepts arguments
#   * series
#   * period
#   * bands_period
#   * bands_deviation
#   * ma_method
#
class Indicator::Mfib < Indicator

  attr_reader :bands_period, :bands_deviation, :ma_method

  private


  def local_defaults
    { period: 14,
      bands_period: 20,
      bands_deviation: 2.0,
      ma_method: :ema
    }
  end

  def mfi
    @mfi ||=  Indicator::Mfi.new(series: series, period: period )
  end

  def bands
    st = size + stop + bands_period
    ser = mfi[stop..st]
    Indicator::Bands.new(series: ser,
                         period: bands_period,
                         deviation: bands_deviation,
                         ma_method: ma_method,
                         price: :main)
  end

  def calculations
    line = new_line
    bands[0..size-1].each do |band|
      line << new_bar(time: band.time, main: band.percent_b)
    end
    line
  end

end
# == Parabolic SAR indicator
#
# Accepts arguments
#   * step
#   * max
#   * period
#
class Indicator::Sar < Indicator

  attr_reader :step, :max

  private

  def local_defaults
    { step:   0.02,
      max:    0.2,
      period: 21
    }
  end

  def calculations
    i = start
    sar = series[i].low
    ep = series[i].high
    af = step
    direction = :up
    line = new_line

    while i > stop
      i -= 1
      q = series[i]

      if direction == :up
        if q.high > ep
          ep = q.high
          af += step if af < max
        end
        sar = sar + af * (ep - sar)
        sar = [ sar, series[i+1].low, series[i+2].low].min

        if q.low < sar
          sar = ep
          ep = q.low
          af = step
          direction = :down
        end

      else
        if q.low < ep
          ep = q.low
          af += step if af < max
        end
        sar = sar + af * (ep - sar)
        sar = [ sar, series[i+1].high, series[i+2].high].max

        if q.high > sar
          sar = ep
          ep = q.high
          af = step
          direction = :up
        end
      end

      if i < size + stop
        line << bar(i, sar)
      end
    end
    line.reverse!
  end


  def bar(index, value)
    new_bar(time: series[index].time,
            main: value.round(digits))
  end

end
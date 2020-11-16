# Money Flow Index technical indicator
#
# Accepts arguments
#   * series
#   * period
#
class Indicator::Mfi < Indicator

  private

  def local_defaults
    {period: 14}
  end

  def calculations
    i = start
    line = new_line

    while i >= stop
      if i < size + stop
        mfi = 100 - (100 / (1 + money_ratio(i)))

        line << bar(i, mfi)
      end
      i -= 1
    end

    line.reverse!
  end

  def bar(index, value)
    new_bar(
        time: series[index - shift].time,
        main: value.round(4)
    )
  end

  def money_flow(index)
    q = series[index]
    q.typical * q.volume
  end

  def money_ratio(index)
    positive = 0
    negative = 0

    period.times do |j|
      flow = money_flow(index + j)
      q = series[index + j]
      prev = series[index + j + 1]

      if q.typical >= prev.typical
        positive += flow
      else
        negative += flow
      end
    end

    positive / negative
  end

end
# == Strategy on SAR
#
class Strategy::Sar < Strategy

  private

  def calculations
    case
    when (series[1].low > sar[1].main) && (series[0].high < sar[0].main) && (ma50.current.main < ma100.current.main)
      :open_sell
    when (series[1].high < sar[1].main) && (series[0].low > sar[0].main) && (ma50.current.main > ma100.current.main)
      :open_buy
    when (series[1].low > sar[1].main) && (series[0].high < sar[0].main)
      :close_buy
    when (series[1].high < sar[1].main) && (series[0].low > sar[0].main)
      :close_sell
    else
      :none
    end
  end


  def defaults
    {
        sar_step: 0.02,
        sar_max: 0.2
    }
  end

end
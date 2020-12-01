class Strategy::Bands < Strategy

  attr_accessor :enter_limit

  private

  def calculations
    case
    when (bands[1].percent_b < 100 - enter_limit) && (bands[0].percent_b >= 100 - enter_limit) && (ma100.current.main > ma150.current.main)
      :open_buy
    when (bands[1].percent_b > enter_limit) && (bands[0].percent_b >= enter_limit) && (ma100.current.main < ma150.current.main)
      :open_sell
    when series.current.low < sar.current.main
      :close_buy
    when series.current.high > sar.current.main
      :close_sell
    else
      :none
    end
  end

  def defaults
    {bands_period: 20,
     bands_deviation: 3.2,
     bands_ma_method: :ema,
     bands_price: :typical,
     sar_step: 0.02,
     sar_max: 0.2,
     mfib_period: 14,
     mfib_bands_priod: 50,
     mfib_bands_deviation: 2.1,
     enter_limit: 10
    }
  end

end
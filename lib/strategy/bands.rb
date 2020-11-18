class Strategy::Bands < Strategy

  attr_accessor :bands_period, :bands_deviation, :bands_ma_method, :bands_price,
                :sar_step, :sar_max,
                :mfib_period, :mfib_bands_priod, :mfib_bands_deviation,
                :enter_limit

  def defaults
    {bands_period: 20,
     bands_deviation: 2.0,
     bands_ma_method: :ema,
     bands_price: :typical,
     sar_step: 0.02,
     sar_max: 0.2,
     mfib_period: 14,
     mfib_bands_priod: 50,
     mfib_bands_deviation: 2.1,
     enter_limit: 30
    }
  end

  def signal
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
  rescue  Series::NoDataError
    :none
  end

  def bands
    @bands ||= series.iBands(period: bands_period, deviation: bands_deviation, ma_method: bands_ma_method, price: bands_price)
  end

  def sar
    @sar ||= series.iSar(step: sar_step, max: sar_max)
  end

  def mfib
    @mfib ||= series.iMfib(period: mfib_period, bands_period: mfib_bands_priod, bands_deviation: mfib_bands_deviation)
  end

  def ma100
    @ma100 ||= series.iMa(period: 100)
  end

  def ma150
    @ma150 ||= series.iMa(period: 150)
  end

end
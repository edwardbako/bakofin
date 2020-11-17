class Strategy::MACross < Strategy

  def signal
    ma = series.iMa(period: 50).current
    case
    when ma.blank?
      :none
    when series.current.open < ma.main && series.current.close > ma.main
      :open_buy
    when series.current.open > ma.main && series.current.close < ma.main
      :open_sell
    else
      :none
    end
  rescue  Series::NoDataError
    :none
  end
end
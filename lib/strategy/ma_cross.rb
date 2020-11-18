class Strategy::MACross < Strategy

  def signal
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

  def ma
    series.iMa(period: 50).current
  end
end

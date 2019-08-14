class Strategy::MACross < Strategy

  def signal
    ma = series.iMa(period: 50).current
    case
    when ma.blank?
      :none
    when series.current.open < ma && series.current.close > ma
      :open_buy
    when series.current.open > ma && series.current.close < ma
      :open_sell
    else
      :none
    end
  end
end
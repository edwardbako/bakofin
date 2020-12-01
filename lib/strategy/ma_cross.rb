class Strategy::MACross < Strategy

  attr_accessor :ma_period

  private

  def defaults
    {ma_period: 50}
  end

  def calculations
    case
    when ma.current.blank?
      :none
    when series.current.open < ma.current.main && series.current.close > ma.current.main
      :open_buy
    when series.current.open > ma.current.main && series.current.close < ma.current.main
      :open_sell
    else
      :none
    end
  end

end

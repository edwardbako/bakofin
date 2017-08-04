class Symb < ApplicationRecord

  has_many :quotes

  # def iMA(timeframe: :h1, period: 20, shift: 0, method: :sma, aplied_price: :price_typical)
  #   result = []
  #   quotes.send(timeframe).find_each.with_index do |q, i|
  #     if i < period
  #       result << nil
  #     else
  #       result << result[-period..-1].sum / period.to_f
  #     end
  #   end
  #   result
  # end

end

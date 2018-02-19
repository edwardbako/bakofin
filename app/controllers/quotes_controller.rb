class QuotesController < ApplicationController

  before_action :set_series

  def index
    range = 0..100
    quotes = @series[range].reverse
    render json: {
             quotes: quotes.to_json(only: [:open, :high, :low, :close], methods: [:x]),
             volumes: quotes.to_json(only: [], methods: [:x, :y]),
             sma: @series.iBands[range].to_json,
             ema: @series.iBands[range].map {|v| [v[0], v[2]]}.to_json
           }
  end

  def show
    range = 0..1
    quotes = @series[range].reverse
    render json: {
             quotes: quotes.to_json(only: [:open, :high, :low, :close], methods: [:x]),
             volumes: quotes.to_json(only: [], methods: [:x, :y]),
             sma: @series.iMA(method: :sma)[range].to_json,
             ema: @series.iBands[range].to_json
           }
  end

  private

  def set_series
    @series = Series.new(symbol: "XAUUSD", timeframe: 1)
  end
end
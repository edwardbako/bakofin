class QuotesController < ApplicationController

  before_action :set_series

  def index
    quotes = @series[0..100]
    render json: {
             quotes: quotes.to_json(only: [:open, :high, :low, :close, :x]),
             volumes: quotes.to_json(only: [:x, :y])
           }
  end

  def show
    quotes = @series[0..1]
    render json: {
             quotes: quotes.to_json(only: [:open, :high, :low, :close, :x]),
             volumes: quotes.to_json(only: [:x, :y])
           }
  end

  private

  def set_series
    @series = Series.new(symbol: "XAUUSD", timeframe: 1)
  end
end
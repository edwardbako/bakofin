class QuotesController < ApplicationController

  def index
    quotes = Quote.where(timeframe: 60).order(time: :desc).limit(1000).reverse
    render json: {
             quotes: quotes.to_json(only: [:open, :high, :low, :close], methods: [:x]),
             volumes: quotes.to_json(only: [], methods: [:x, :y])
           }
  end
end
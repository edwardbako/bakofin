class Series
  include ActiveModel::Model
  include Redis::Objects
  # include Enumerable

  attr_accessor :symbol, :timeframe

  validates_presence_of :symbol, :timeframe

  list :time, marshal: true, map: :to_time
  list :open, marshal: true, map: :to_f
  list :high, marshal: true, map: :to_f
  list :low, marshal: true, map: :to_f
  list :close, marshal: true, map: :to_f
  list :volume, marshal: true, map: :to_i

  def id
    if valid?
      "#{symbol}:#{timeframe}"
    else
      Rails.logger.error "Record invalid: #{errors.full_messages.join(', ')}"
      nil
    end
  end

  def at(index)
    if index.is_a? Integer
      result = [{
        time: time[index],
        x: time[index].to_i * 1000,
        open: open[index],
        high: high[index],
        low: low[index],
        close: close[index],
        volume: volume[index],
        y: volume[index]
      }]
    else
      result = time[index].map { |v| {time: v} }
      x = time[index].map { |v| {x: v.to_i * 1000} }
      o = open[index].map { |v| {open: v} }
      h = high[index].map { |v| {high: v} }
      l = low[index].map { |v| {low: v} }
      c = close[index].map { |v| {close: v} }
      v = volume[index].map { |v| {volume: v} }
      y = volume[index].map { |v| {y: v} }
      result.each_with_index do |q, i|
        q.merge!(o[i]).merge!(h[i]).merge!(l[i]).merge!(c[i]).merge!(v[i]).merge!(x[i]).merge!(y[i])
      end
    end
    result
  end

  def [](index)
    at index
  end

  def iMA(**args)
    MA.new **args.merge(series: self)
  end


end
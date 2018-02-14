class Series
  include ActiveModel::Model
  include Redis::Objects
  # include Enumerable

  class RecordInvalid < StandardError; end

  def initialize(attributes={})
    super
    raise RecordInvalid, errors.full_messages.join(', ') unless valid?
  end

  attr_accessor :symbol, :timeframe

  validates_presence_of :symbol, :timeframe

  list :time, marshal: true, map: :to_time
  list :open, marshal: true, map: :to_f
  list :high, marshal: true, map: :to_f
  list :low, marshal: true, map: :to_f
  list :close, marshal: true, map: :to_f
  list :volume, marshal: true, map: :to_i

  def id
    "#{symbol}:#{timeframe}"
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

  def index_of_time(ti)
    i = 0
    time.each do |t|
      break if t < ti
      i += 1
    end
    i
  end

  [:MA, :Bands, :MFI].each do |m|
    define_method "i#{m}" do |**args|
      # noinspection RubyArgCount
      "Indicator::#{m}".constantize.new(**args.merge(series: self))
    end
  end

end
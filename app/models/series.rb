class Series
  include ActiveModel::Model
  include Redis::Objects
  # include Enumerable
  Concurrent

  class Error < StandardError; end
  class RecordInvalid < Error; end

  def initialize(attributes={})
    super
    raise RecordInvalid, errors.full_messages.join(', ') unless valid?
  end

  attr_accessor :symbol, :timeframe

  validates_presence_of :symbol, :timeframe

  list :time#, marshal: true, map: :to_time
  list :open, marshal: true, map: :to_f
  list :high, marshal: true, map: :to_f
  list :low, marshal: true, map: :to_f
  list :close, marshal: true, map: :to_f
  list :volume, marshal: true, map: :to_i

  list :quotes

  def id
    "#{symbol}:#{timeframe}"
  end

  def time_parsed
    time.map { |v| Time.rfc3339 v}
  end

  def at(index)
    if index.is_a? Integer
      result = [{
        time: time[index],
        # x: Time.rfc3339(time[index]).to_i * 1000,
        open: open[index],
        high: high[index],
        low: low[index],
        close: close[index],
        volume: volume[index],
        # y: volume[index]
      }]
    else
      result = time[index].map { |v| {time: v} }
      # x = time[index].map { |v| {x: Time.rfc3339(v).to_i * 1000} }
      o = open[index].map { |v| {open: v} }
      h = high[index].map { |v| {high: v} }
      l = low[index].map { |v| {low: v} }
      c = close[index].map { |v| {close: v} }
      v = volume[index].map { |v| {volume: v} }
      # y = volume[index].map { |v| {y: v} }
      result.each_with_index do |q, i|
        q.merge!(o[i]).merge!(h[i]).merge!(l[i]).merge!(c[i]).merge!(v[i])#.merge!(x[i]).merge!(y[i])
      end
    end
    result
  end

  def [](index)
    at index
  end

  def index_by(**params)
    unless params.key?(:time)
      raise NotImplementedError, "Object of class #{self.class.to_s} searches index only by time field."
    end
    i = 0
    time.each do |t|
      break if Time.rfc3339(t) < params[:time]
      i += 1
    end
    i
  end

  def index_of(**params)
    unless params.key?(:time)
      raise NotImplementedError, "Object of class #{self.class.to_s} searches index only by time field."
    end
    i = 0
    all.each do |q|
      break if Time.rfc3339(q.time) < params[:time]
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

  Struct.new("Qq", :time, :open, :high, :low, :close, :volume)

  def all
    quotes.map {|q| mine_quote q}
  end

  def range(index)
    if index.is_a? Integer
      mine_quote quotes[index]
    else
      quotes[index].map {|q| mine_quote q}
    end
  end

  def convert_all_to_new_format
    quo = range 0..100000
    to_push = quo.map { |q| [q.time, q.open, q.high, q.low, q.close, q.volume].join('|') }
    quotes.push *to_push
  end

  def mine_quote(str)
    Struct::Qq.new *(str.split('|'))
  end

end
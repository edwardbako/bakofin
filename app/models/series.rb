class Series
  include ActiveModel::Model
  include Redis::Objects
  # include Enumerable

  class Error < StandardError; end
  class RecordInvalid < Error; end

  def initialize(attributes={})
    super
    raise RecordInvalid, errors.full_messages.join(', ') unless valid?
  end

  attr_accessor :symbol, :timeframe

  validates_presence_of :symbol, :timeframe

  list :data

  def id
    "#{symbol}:#{timeframe}"
  end

  def at(index)
    if index.is_a? Integer
      parse_quote data[index]
    else
      data[index].map {|q| parse_quote q}
    end
  end

  def [](index)
    at index
  end

  def index_by(**params)
    unless params.key?(:time)
      raise NotImplementedError, "Object of class #{self.class.to_s} searches index only by time field."
    end
    i = 0
    all.each do |q|
      break if q.time < params[:time]
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

  def all
    data.map {|q| parse_quote q}
  end

  private

  def parse_quote(str)
    data = str.split('|')
    Quote.new time: Time.rfc3339(data[0]),
              open: data[1].to_f,
              high: data[2].to_f,
              low: data[3].to_f,
              close: data[4].to_f,
              volume: data[5].to_i
  end

end
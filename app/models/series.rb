# == Series
#
# Retrieving quotes data from Redis. Requires Redis to store list in the following format:
#
#   "yyyy-mm-ddThh:mm:ss+00:00|open|high|low|close|volume"
#   key: "series:#{symbol}:#{timeframe}"
#


class Series
  include ActiveModel::Model
  include Redis::Objects
  # include Enumerable
  include Loggable

  class Error < StandardError; end
  class RecordInvalid < Error; end
  class NoDataError < Error; end

  def initialize(attributes={})
    super
    @logger = attributes[:logger]
    raise RecordInvalid, errors.full_messages.join(', ') unless valid?
  end

  attr_accessor :symbol, :timeframe, :test

  validates_presence_of :symbol, :timeframe

  list :data

  def id
    "#{symbol}:#{timeframe}#{test ? ':test' : ''}"
  end

  def size
    data.size
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

  def last
    at 0
  end

  alias_method :current, :last

  def specification
    specification = Specification.where(symbol: symbol).first
    # raise NoDataError, "There is no specification for #{symbol} symbol."
    specification.test = test
    specification
  end

  def digits
    specification.precision
  end

  # def index_by(**params)
  #   unless params.key?(:time)
  #     raise NotImplementedError, "Object of class #{self.class.to_s} searches index only by time field."
  #   end
  #   i = 0
  #   all.each do |q|
  #     break if q.time < params[:time] #TODO What if date not found?
  #     i += 1
  #   end
  #   i
  # end

  def all
    data.map {|q| parse_quote q}
  end

  # def time_period(from: nil, to: nil)
  #   if from.present? && to.present?
  #     raise Error, ':from time must be earlier than :to time' if to < from
  #   end
  #   start = from.present? ? index_by(time: from) : size
  #   stop = to.present? ? index_by(time: to)-1 : 0
  #   self[stop..start]
  # end

  private_class_method def self._indicators_list
    Dir.entries("lib/indicator")[2..-1].map {|x| File.basename(x, ".rb").camelize }
  end

  _indicators_list.each do |m|
    define_method "i#{m}" do |**args|
      # noinspection RubyArgCount
      "Indicator::#{m}".constantize.new(**args.merge(series: self))
    end
  end

  private

  def parse_quote(str)
    if str.blank?
      raise NoDataError, "There is no data available for #{symbol} symbol on #{timeframe} timeframe"
    end

    data = str.split('|')
    Quote.new time: Time.rfc3339(data[0]),
              open: data[1].to_f,
              high: data[2].to_f,
              low: data[3].to_f,
              close: data[4].to_f,
              volume: data[5].to_i
  end


end
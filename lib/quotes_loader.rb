require 'csv'


# == QuotesLoader
#
# Loads data from different sources to Redis.
#
class QuotesLoader
  include Loggable

  class Error < StandardError; end
  class NoDataError < Error; end

  SUPPORTED_EXTENSIONS = ['csv']
  PATH = Rails.root.join 'data'
  FILES = %w(XAUUSD1.csv XAUUSD5.csv XAUUSD15.csv XAUUSD30.csv XAUUSD60.csv
             XAUUSD240.csv XAUUSD1440.csv)
  TIMEZONE = "+03:00"

  attr_accessor :path, :filename, :symbol, :timeframe, :test

  def initialize(path: PATH, symbol: nil, timeframe: nil, test:false, logger: nil)
    @path = path
    @symbol = symbol
    @timeframe = timeframe
    @test = test
    @logger = logger
  end

  def raw_data
    @raw_data ||= readfile
  end

  def size
    @size ||= raw_data.size
  end

  def reload!
    @raw_data = readfile
  end

  def filename
    "#{symbol}#{timeframe}.csv"
  end

  def redis_key
    "series:#{symbol}:#{timeframe}#{test_key_ext}:data"
  end

  def redis_ask_key
    "#{symbol}:ask#{test_key_ext}"
  end

  def redis_bid_key
    "#{symbol}:bid#{test_key_ext}"
  end

  def load_to_redis
    logger.info(prog_name) { "Loading to Redis has started..."}
    clear_redis

    i = 0
    raw_data.each do |q|
      logger.debug(prog_name) { "Loading #{i} / #{size} bar." }
      $redis.lpush redis_key, formatted_quote(q)
      $redis.set redis_ask_key, ask(q)
      $redis.set redis_bid_key, bid(q)
      logger.debug(prog_name) { "Loaded #{formatted_quote(q)}" }
      logger.debug(prog_name) { "Ask set to #{ask(q)}" }
      logger.debug(prog_name) { "Bid set to #{bid(q)}"}
      i += 1
      yield i, size if block_given?
       "\rProcessed #{i} / #{size} bars"
    end
    puts "\n\n"
    logger.debug(prog_name) { "Loaded #{size} bars."}
  ensure
    clear_redis
  end

  def self.process_all
    FILES.each do |fname|
      loader = new(path: PATH, filename: fname)
      loader.load_to_redis
    end
  end

  private

  def clear_redis
    if test
      logger.debug(prog_name) { "Clearing redis key -- #{redis_key}: #{$redis.del(redis_key)}"}
      logger.debug(prog_name) { "Clearing redis key -- #{redis_ask_key}: #{$redis.del(redis_ask_key)}"}
      logger.debug(prog_name) { "Clearing redis key -- #{redis_bid_key}: #{$redis.del(redis_bid_key)}"}
    end
  end

  # def filename_parsed
  #   filename =~ /(\p{L}+)(\d+).(\w*)/
  #
  #   unless SUPPORTED_EXTENSIONS.include? $3
  #     raise StandardError, "You have provided file with extension (#{$3}) that is not supported. Supported extensions: #{SUPPORTED_EXTENSIONS}"
  #   end
  #
  #   [$1, $2, $3]
  # end

  def test_key_ext
    test ? ':test' : ''
  end

  def readfile
    # self.symbol = filename_parsed[0]
    # self.timeframe = filename_parsed[1].to_i
    file = File.join(path, filename)
    logger.debug(prog_name) { "Reading file: #{file}"}
    unless File.exist? file
      raise NoDataError, "There is no data for symbol #{symbol} on timeframe #{timeframe}"
    end
    CSV.read(file)
  end

  def formatted_quote(q)
    "#{q[0].gsub('.','-')}T#{q[1]}:00#{TIMEZONE}|#{q[2]}|#{q[3]}|#{q[4]}|#{q[5]}|#{q[6]}"
  end

  def ask(q)
    [q[2], q[5]].max
  end

  def bid(q)
    [q[2], q[5]].min
  end
end
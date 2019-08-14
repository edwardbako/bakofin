require 'csv'


# == QuotesLoader
#
# Loads data from different sources to Redis.
#
class QuotesLoader

  class Error < StandardError; end
  class NoDataError < Error; end

  SUPPORTED_EXTENSIONS = ['csv']
  PATH = Rails.root.join 'data'
  FILES = %w(XAUUSD1.csv XAUUSD5.csv XAUUSD15.csv XAUUSD30.csv XAUUSD60.csv
             XAUUSD240.csv XAUUSD1440.csv)
  TIMEZONE = "+03:00"

  attr_accessor :path, :filename, :symbol, :timeframe, :test

  def initialize(path: PATH, symbol: nil, timeframe: nil, test:false)
    @path = path
    @symbol = symbol
    @timeframe = timeframe
    @test = test
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
    "series:#{symbol}:#{timeframe}#{test ? ':test' : ''}:data"
  end

  def load_to_redis
    puts "LOADING TO REDIS"
    $redis.del redis_key

    i = 0
    raw_data.each do |q|
      $redis.lpush redis_key, formatted_quote(q)
      i += 1
      yield i, size if block_given?
      print "\rProcessed #{i} / #{size} bars"
    end
    puts "\n\n"
  ensure
    $redis.del redis_key if test
  end

  def self.process_all
    FILES.each do |fname|
      loader = new(path: PATH, filename: fname)
      loader.load_to_redis
    end
  end

  private

  # def filename_parsed
  #   filename =~ /(\p{L}+)(\d+).(\w*)/
  #
  #   unless SUPPORTED_EXTENSIONS.include? $3
  #     raise StandardError, "You have provided file with extension (#{$3}) that is not supported. Supported extensions: #{SUPPORTED_EXTENSIONS}"
  #   end
  #
  #   [$1, $2, $3]
  # end

  def readfile
    # self.symbol = filename_parsed[0]
    # self.timeframe = filename_parsed[1].to_i
    file = File.join(path, filename)
    unless File.exist? file
      raise NoDataError, "There is no data for symbol #{symbol} on timeframe #{timeframe}"
    end
    CSV.read(file)
  end

  def formatted_quote(q)
    "#{q[0].gsub('.','-')}T#{q[1]}:00#{TIMEZONE}|#{q[2]}|#{q[3]}|#{q[4]}|#{q[5]}|#{q[6]}"
  end
end
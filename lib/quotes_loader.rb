require 'csv'

class QuotesLoader

  class StandardError < StandardError; end

  SUPPORTED_EXTENSIONS = ['csv']
  PATH = Rails.root.join 'data'
  FILES = %w(XAUUSD1.csv XAUUSD5.csv XAUUSD15.csv XAUUSD30.csv XAUUSD60.csv
             XAUUSD240.csv XAUUSD1440.csv)

  attr_accessor :path, :filename, :symbol, :timeframe

  def initialize(path: PATH, filename: nil)
    @path = path
    @filename = filename
  end

  def raw_data
    @raw_data ||= readfile
  end

  def reload!
    @raw_data = readfile
  end

  def symbol
    @symbol ||= filename_parsed[0]
  end

  def timeframe
    @timeframe ||= filename_parsed[1].to_i
  end

  def create_quotes
    symb = Symb.find_or_create_by(name: symbol)

    raw_data.each do |q|
      quote = Quote.find_or_create_by(
             symb: symb,
             timeframe: timeframe,
             time: "#{q[0]} #{q[1]} +0300".to_time(:utc)
      )
      quote.update_attributes(
        open: q[2].to_f,
        high: q[3].to_f,
        low: q[4].to_f,
        close: q[5].to_f,
        volume: q[6]
      )
    end
  end

  def self.process
    FILES.each do |fname|
      loader = new(PATH, fname)
      loader.create_quotes
    end
  end

  private

  def filename_parsed
    filename =~ /(\p{L}+)(\d+).(\w*)/

    unless SUPPORTED_EXTENSIONS.include? $3
      raise StandardError, "You have provided file with extension (#{$3}) that is not supported."
    end
    [$1, $2, $3]
  end

  def readfile
    self.symbol = filename_parsed[0]
    self.timeframe = filename_parsed[1].to_i
    CSV.read(File.join(path, filename))
  end
end
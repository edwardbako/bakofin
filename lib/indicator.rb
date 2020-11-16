# == Indicator
#
# It is a main class to calculate technical indicators on series.
#
# Indicator returns series-like object of Line class. It could be used to calculate new indicator.
# Subclass this to provide new functionality.
#
# = Accessing Elements
#
# Elements in an indicator can be retrieved using the Indicator#[] method.  It can
# take a single integer argument (a numeric index) or a range.
# Negative indices are not supported.
#

class Indicator

  class Error < StandardError
    def initialize(msg=nil)
      @message = msg
    end

    def message
      "A big problem here: #{@message} "
    end
  end

  class BlankSeriesError < Error
    def message
      super + 'You have no provided series object. '
    end
  end

  class IncorrectPriceError < Error
    def message
      super + "Incorrect price type provided. "
    end
  end

  class BlankIndexError < Error
    def message
      super + "Dob't know how to calculate indicator on blank index. "
    end
  end

  attr_reader :series, :size, :period, :shift
  attr_accessor :range

  def initialize(**args)
    args.reverse_merge! defaults
    args.each do |key, value|
      instance_variable_set "@#{key}", value
    end
    raise Indicator::BlankSeriesError if series.blank?
    post_initialize(args)
  end

  def [](index)
    raise BlankIndexError if index.blank?
    self.range = index

    if range.is_a?(Range)
      calculations
    else
      calculations.first
    end
  end

  def current
    self[0]
  end

  private

  def post_initialize(args)
    nil
  end

  def calculations
    new_line
  end

  def defaults
    {series: nil, period: 0, shift: 0}.merge! local_defaults
  end

  def local_defaults
    {}
  end

  def digits
    @digits ||= series.digits
  end

  def new_line
    Line.new(digits: digits)
  end

  def new_bar(**args)
    bar = OpenStruct.new(**args)
    bar.x = bar.time.to_i * 1000 if args[:time].present?
    bar
  end


  def start
    ( range.is_a?(Range) ? range.last + period : range + period ) + shift if range.present?
  end

  def stop
    ( range.is_a?(Range) ? range.first : range ) + shift if range.present?
  end

  def size
    start - stop - period + 1
  end


end
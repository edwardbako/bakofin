class Quote
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  attr_accessor :time, :open, :high, :low, :close, :volume

  def attributes
    {time: nil, open: nil, high: nil, low: nil, close: nil, volume: nil}.stringify_keys
  end

  alias_method :y, :volume

  def x
    time.to_i * 1000
  end

  def name
    time.to_formatted_s
  end

  def medial
    (high + low) / 2
  end

  def typical
    (high + low + close) / 3
  end

  def weighted
    (high + low + 2 * close) / 4
  end

  def to_s
    "time=" + "#{time}".blue.bold +
    ",\t open=" + "#{open}".magenta.bold +
    ",\t high=" + "#{high}".magenta.bold +
    ",\t low=" + "#{low}".magenta.bold +
    ",\t close=" + "#{close}".magenta.bold +
    ",\t volume=" + "#{volume}".yellow.bold
  end

end

# == Quote
class Quote
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  attr_accessor :time, :open, :high, :low, :close, :volume

  def attributes
    { time:, open:, high:, low:, close:, volume: }.stringify_keys
  end

  alias y volume

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
    <<~STR
      time = #{time.to_s.blue.bold}, \
      open = #{open.to_s.magenta.bold}, \
      high = #{high.to_s.magenta.bold}, \
      low = #{low.to_s.magenta.bold}, \
      close = #{close.to_s.magenta.bold}, \
      volume = #{volume.to_s.yellow.bold}
    STR
  end
end

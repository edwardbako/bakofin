# == Strategy
#
# Performs calculation of trading signals, such as *Open Buy Order*, *Close Sell Order* etc.
# It could use information of quotes series and indicators at given position of time.
class Strategy

  attr_accessor :series

  def initialize(series: nil)
    @series = series
  end

  def signal(*args)
    raise NotImplementedError, 'This method is from Strategy class. Implement it in subclass at wish.'
  end

end
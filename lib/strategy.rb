# == Strategy
#
# Performs calculation of trading signals, such as *Open Buy Order*, *Close Sell Order* etc.
# It could use information of quotes series and indicators at given position of time.
class Strategy

  attr_accessor :series

  def initialize(**args)
    args.reverse_merge! defaults
    args.each do |key, value|
      instance_variable_set "@#{key}", value
    end

  end

  def defaults
    {}
  end

  def signal(*args)
    raise NotImplementedError, 'This method is from Strategy class. Implement it in subclass at wish.'
  end

end
module Indicator

  class Error < StandardError
    def initialize(msg=nil)
      @message = msg
    end

    def message
      "A big problem here: #{@message}"
    end
  end

  class BlankSeriesError < Error
    def message
      super + 'You have no provided series object.'
    end
  end

end
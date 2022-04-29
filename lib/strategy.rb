# == Strategy
#
# Performs calculation of trading signals, such as *Open Buy Order*, *Close Sell Order* etc.
# It could use information of quotes series and indicators at given position of time.
class Strategy

  include Loggable

  attr_accessor :series,
                :ma_period,
                :bands_period, :bands_deviation, :bands_ma_method, :bands_price,
                :sar_step, :sar_max,
                :mfib_period, :mfib_bands_priod, :mfib_bands_deviation

  def initialize(**args)
    args.reverse_merge! defaults
    args.each do |key, value|
      instance_variable_set "@#{key}", value
    end

  end

  def signal(*args)
    logger.debug(prog_name) { "Performing calculations on current quote: #{series.current.inspect}"}
    # raise NotImplementedError, 'This method is from Strategy class. Implement it in subclass at wish.'
    calculations
  rescue  Series::NoDataError
    :none
  end

  private

  def calculations
    :none
  end

  def defaults
    {}
  end

  def bands
    @bands ||= series.iBands(period: bands_period, deviation: bands_deviation, ma_method: bands_ma_method, price: bands_price)
  end

  def sar
    @sar ||= series.iSar(step: sar_step, max: sar_max)
  end

  def mfib
    @mfib ||= series.iMfib(period: mfib_period, bands_period: mfib_bands_priod, bands_deviation: mfib_bands_deviation)
  end

  def ma
    @ma ||= series.iMa(period: ma_period)
  end

  def ma50
    @ma50 ||= series.iMa(period: 50)
  end

  def ma100
    @ma100 ||= series.iMa(period: 100)
  end

  def ma150
    @ma150 ||= series.iMa(period: 150)
  end

  def ma200
    @ma200 ||= series.iMa(period: 200)
  end


end
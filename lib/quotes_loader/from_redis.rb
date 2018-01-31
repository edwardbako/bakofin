class QuotesLoader::FromRedis

  attr_accessor :symbol, :timeframe, :quote, :channel
  def initialize(symbol = "XAUUSD", timeframe: 1)
    @symbol = Symb.find_by name: symbol
    @timeframe = timeframe
    @channel = "#{@symbol.name};#{timeframe};tick"
  end

  def run
    $redis.subscribe(channel) do |on|
      on.message do |ch, m|
        self.quote = hashify_message m
        last = Quote.find_by(symb: symbol, timeframe: timeframe, time: quote[:time])
        if last.present?
          last.update(quote.except(:time))
        else
          $redis.unsubscribe channel
        end
      end
    end
    load_history
  end

  def load_history
    time = quote[:time] - 15.days
    key = "#{symbol.name};#{timeframe};#{time.strftime("%Y-%-m-%-d-%k:")}#{time.min.to_s}+3"
    r = $redis.mapped_hmget(time.strftime("%Y-%-m-%-d-%k:") + time.min.to_s,
                        :open, :high, :low, :close, :volume, :time)
    puts key
    puts r
    # temp = false
    # until temp.present?
    #   temp = Quote.find_or_create_by symbol: symbol, timeframe: timeframe, time: time
    # end
    # run
  end

  private

  def hashify_message(m)
    result = JSON.parse(m).map {|k, v| [k, v.to_f]}.to_h.symbolize_keys
    result[:time] = Time.at(result[:time] - 3*60*60).in_time_zone
    result
  end


end
class Series
  include ActiveModel::Model
  include Redis::Objects

  attr_accessor :symbol, :timeframe

  validates_presence_of :symbol, :timeframe

  list :time, marshal: true, map: :to_time
  list :open, marshal: true, map: :to_f
  list :high, marshal: true, map: :to_f
  list :low, marshal: true, map: :to_f
  list :close, marshal: true, map: :to_f
  list :volume, marshal: true, map: :to_i

  def id
    if valid?
      "#{symbol}:#{timeframe}"
    else
      Rails.logger.error "Record invalid: #{errors.full_messages.join(', ')}"
      nil
    end
  end

  def at(index)
    {
      time: time[index],
      open: open[index],
      high: high[index],
      low: low[index],
      close: close[index],
      volume: volume[index]
    }
  end

  def [](index)
    at index
  end

  def follow
    puts "Time\t\t\t\t Open \t\t High \t\t Low \t\t Close \t\t Volume"
    10.times do |i|
      puts "#{time[10-i]} \t #{open[10-i]} \t #{high[10-i]} \t #{low[10-i]} \t #{close[10-i]} \t #{volume[10-i]}"
    end
    c = self.time[0]
    hp = high[0]
    lp = low[0]
    clp = close[0]
    while true
      if c == self.time[0]
        h = high[0]
        l = low[0]
        cl = close[0]

        print "#{time[0]} \t #{open[0]}".light_yellow.bold
        h > hp ? print(" \t #{h}".light_green.bold) : print(" \t #{h}".light_yellow.bold)
        l < lp ? print(" \t #{l}".light_red.bold) : print(" \t #{l}".light_yellow.bold)
        if cl > clp
          print(" \t #{cl}".light_green.bold)
        elsif cl < clp
          print(" \t #{cl}".light_red.bold)
        else
          print(" \t #{cl}".light_yellow.bold)
        end
        print " \t #{volume[0]}".light_yellow.bold
        print " \t :#{60 - (Time.now - time[0]).to_i} \t\r\r"
        hp = h
        lp = l
        clp = cl
      else
        puts "#{time[1]} \t #{open[1]} \t #{high[1]} \t #{low[1]} \t #{close[1]} \t #{volume[1]}                "
        c = self.time[0]
      end
      sleep 1
    end
  end

end
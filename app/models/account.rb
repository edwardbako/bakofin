# == Account
#
# Stores information about money movement
#   * login
#   * password
#   * server
#   * balance
#   * current_margin
class Account < ApplicationRecord

  has_secure_password
  has_many :orders
  belongs_to :test_pass, optional: true

  def balance
    orders.closed.sum(&:profit)
  end

  def starting_balance
    orders.closed.order(:close_date).first.profit
  end

  def history
    balance = 0
    @history ||= orders.closed.order(:close_date).map { |o| (balance += o.profit).to_s }
  end

  def net_profit
    deals.sum(&:profit)
  end

  def total_profit
    profitable_deals.sum(&:profit)
  end

  def total_loss
    loss_deals.sum(&:profit)
  end

  def buy_positions
    deals.buy
  end

  def sell_positions
    deals.sell
  end

  def deals
    @deals ||= orders.closed.where.not(kind: :balance)
  end

  def profitable_deals
    deals.select {|o| o.profit > 0 }
  end

  def profitable_deals_percentage
    (profitable_deals.count.to_f / deals.count * 100).to_s :percentage, precision: 1
  end

  def loss_deals
    deals.select {|o| o.profit <= 0 }
  end

  def loss_deals_percentage
    (loss_deals.count.to_f / deals.count * 100).to_s :percentage, precision: 1
  end

  def best_profitable_deal
    profitable_deals.max { |a,b| a.profit <=> b.profit }
  end

  def worst_loss_deal
    loss_deals.min { |a,b,| a.profit <=> b.profit }
  end

  def profit_per_deal
    total_profit / profitable_deals.count
  end

  def loss_per_deal
    total_loss / loss_deals.count
  end

  def continuous
    result = []
    sum = 0
    count = 0

    deals.each do |o|
      profit = o.profit
      if (sum >= 0 && profit >= 0) || (sum < 0 && profit < 0)
        sum += profit
        count += 1
      else
        result << OpenStruct.new(count: count, sum: sum)
        count = 1
        sum = profit
      end
    end

    result << OpenStruct.new(count: count, sum: sum)

    result
  end

  def continuous_win_by_count
    continuous.select {|e| e.sum > 0}.max_by(&:count)
  end

  def continuous_win_by_profit
    continuous.select {|e| e.sum > 0}.max_by(&:sum)
  end

  def continuous_loss_by_count
    continuous.select {|e| e.sum < 0}.max_by(&:count)
  end

  def continuous_loss_by_loss
    continuous.select {|e| e.sum < 0}.min_by(&:sum)
  end

  def mid_continuous_win_count
    c = continuous.select {|e| e.sum > 0}
    (c.map(&:count).sum / c.size.to_f).round(1)
  end

  def mid_continuous_loss_count
    c = continuous.select {|e| e.sum < 0}
    (c.map(&:count).sum / c.size.to_f).round(1)
  end

  def mid_retention_time
    (deals.sum(&:retention_time) / deals.count).inspect
  end

  def win_expectation
    net_profit / deals.count
  end

  def standard_deviation
    mx = win_expectation
    sum = 0
    deals.each do |o|
      ot = (o.profit - mx).cents
      sum += ot ** 2
    end
    d = sum / (deals.count - 1)
    (Math.sqrt(d) / 100).to_money
  end

  def hpr
    ar = history
    prev = ar.first.to_f

    # Holding Period Returns
    hpr = history[1..-1].map do |p|
      res = (p.to_f / prev).round(2)
      prev = p.to_f
      res
    end

    # Average Holding Period Returns
    ahpr = (hpr.sum / hpr.size) .round(5)

    sum = 0
    hpr.each do |p|
      sum += (p - ahpr) ** 2
    end
    # Standard Deviation
    sd = Math.sqrt(sum / hpr.size).round(5)

    {hpr: hpr, ahpr: ahpr, sd: sd}
  end

  def sharpe_ratio(risk_free_rate = 0)
    h = hpr
    ((h[:ahpr] - (1 + risk_free_rate)) / h[:sd]).round(5)
  end

  def profit_factor
    (total_profit / total_loss.abs).round(2)
  end

  def recovery_factor
    (net_profit / drawdowns.max_by(&:down).down).round(2)
  end

  def absolute_drawdown
    min = history.map(&:to_money).min
    if min < starting_balance
      starting_balance - min
    else
      0.to_money
    end
  end

  def drawdowns
    h = history.map(&:to_f)
    ep = h.first
    min = ep
    downs = []

    h.each do |balance|
      if balance >= ep
        down = ep - min
        downs << OpenStruct.new(down: down.to_money, rel:  down/ep) if down > 0
        ep = balance
        min = ep
      else
        min = balance if balance < min
      end
    end

    down = ep - min
    downs << OpenStruct.new(down: down.to_money, rel:  down/ep) if down > 0

    downs
  end

  def max_drawdown
    drawdowns.max_by(&:down).down
  end

  def max_drawdown_percentage
    (drawdowns.max_by(&:down).rel * 100).round(2)
  end

  def relative_drawdown
    drawdowns.max_by(&:rel).down
  end

  def relative_drawdown_percentage
    (drawdowns.max_by(&:rel).rel * 100).round(2)
  end

  def report
    ActiveRecord::Base.logger.silence do
      puts "Report on Account: #{login}".bold
      puts "-----------------"
      # puts "Bars Processed \t\t\t" + "#{bars_processed}".bold
      puts "Starting deposit \t\t" + "#{starting_balance.format(format)}".bold
      puts "Deposit on close \t\t" + "#{balance.format(format)}".bold
      puts "Profit factor \t\t\t" + "#{profit_factor}".bold
      puts "Sharpe ratio \t\t\t" + "#{sharpe_ratio}".bold
      puts "Recovery factor \t\t" + "#{recovery_factor}".bold
      puts "-----------------"
      puts "Net profit \t\t\t" + "#{net_profit.format(format)}".bold
      puts "Total profit \t\t\t" + "#{total_profit.format(format)}".bold
      puts "Total loss \t\t\t" + "#{total_loss.format(format)}".bold
      puts "Win expectation \t\t"  + "#{win_expectation.format(format)}".bold
      puts "Standard deviation \t\t" + "#{standard_deviation.format(format)}".bold
      puts "Absolute drawdown \t\t" + "#{absolute_drawdown.format(format)}".bold
      puts "Maximum drawdown \t\t" + "#{max_drawdown.format(format)} (#{max_drawdown_percentage}%)".bold
      puts "Relative drawdown \t\t" + "#{relative_drawdown_percentage}% (#{relative_drawdown.format(format)})".bold
      puts "-----------------"
      puts "Total deals count \t\t" + "#{deals.count}".bold
      puts "Buy deals count \t\t" + "#{buy_positions.count}".bold
      puts "Sell deals count \t\t" + "#{sell_positions.count}".bold
      puts "Profitable deals (% of all) \t" + "#{profitable_deals.count} (#{profitable_deals_percentage})".bold
      puts "Loss deals (% of all) \t\t" + "#{loss_deals.count} (#{loss_deals_percentage})".bold
      puts "Best profitable deal \t\t" + "#{best_profitable_deal.profit.format(format)}".bold
      puts "Worst loss deal \t\t" + "#{worst_loss_deal.profit.format(format)}".bold
      puts "Mid profit per deal \t\t" + "#{profit_per_deal.format(format)}".bold
      puts "Mid loss per deal \t\t" + "#{loss_per_deal.format(format)}".bold
      puts "Max continuous win by count \t" + "#{continuous_win_by_count.count} (#{continuous_win_by_count.sum.format(format)})".bold
      puts "Max continuous loss by count \t" + "#{continuous_loss_by_count.count} (#{continuous_loss_by_count.sum.format(format)})".bold
      puts "Max continuous win by profit \t" + "#{continuous_win_by_profit.sum.format(format)} (#{continuous_win_by_profit.count})".bold
      puts "Max continuous loss by loss  \t" + "#{continuous_loss_by_loss.sum.format(format)} (#{continuous_loss_by_loss.count})".bold
      puts "Mid continuous wins count \t" + "#{mid_continuous_win_count}".bold
      puts "Mid continuous losses count \t" + "#{mid_continuous_loss_count}".bold
      puts "-----------------"
      puts "Mid retention time \t\t" + "#{mid_retention_time}".bold
      # TODO: Implement report
      # Also we need some charts:
      #   + * balance history
      #   * MFE
      #   * MAE
      #   * Z-score ?
    end
  end

  private

  def format
    {format: '%u %n', thousands_separator: " "}
  end
end
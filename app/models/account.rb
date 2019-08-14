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
    orders.closed.map { |o| o.profit }.sum
  end

  def starting_balance
    orders.closed.order(:close_date).first.profit
  end

  def history
    balance = 0
    orders.closed.order(:close_date).map { |o| (balance += o.profit).to_s }
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
    orders.closed.where.not(kind: :balance)
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

  def continuous_win
    max_count = 0
    max_profit = 0

    count = 0
    profit = 0

    deals.each do |o|
      if o.profit > 0
        count += 1
        profit += o.profit
      else
        if count > max_count
          max_count = count
          max_profit = profit
        end
        count = 0
        profit = 0
      end
    end

    if count > max_count
      max_count = count
      max_profit = profit
    end

    [max_count, max_profit]
  end

  def continuous_loss
    max_count = 0
    max_profit = 0

    count = 0
    profit = 0

    deals.each do |o|
      if o.profit <= 0
        count += 1
        profit += o.profit
      else
        if count > max_count
          max_count = count
          max_profit = profit
        end
        count = 0
        profit = 0
      end
    end

    if count > max_count
      max_count = count
      max_profit = profit
    end

    [max_count, max_profit]
  end

  def report
    ActiveRecord::Base.logger.silence do
      puts "Report on Account: #{login}".bold
      puts "-----------------"
      # puts "Bars Processed \t\t\t" + "#{bars_processed}".bold
      puts "Starting deposit \t\t" + "#{starting_balance.format}".bold
      puts "Deposit on close \t\t" + "#{balance.format}".bold
      puts "Profit factor \t\t\t" + "N/A"
      puts "Sharpe ratio \t\t\t" + "N/A"
      puts "Recovery factor \t\t" + "N/A"
      puts "-----------------"
      puts "Net profit \t\t\t" + "#{net_profit.format}".bold
      puts "Total profit \t\t\t" + "#{total_profit.format}".bold
      puts "Total loss \t\t\t" + "#{total_loss.format}".bold
      puts "Win expectation \t\t"  + "N/A"
      puts "Absolute drawdown \t\t" + "N/A"
      puts "Maximum drawdown \t\t" + "N/A"
      puts "Relative drawdown \t\t" + "N/A"
      puts "-----------------"
      puts "Total deals count \t\t" + "#{deals.count}".bold
      puts "Buy deals count \t\t" + "#{buy_positions.count}".bold
      puts "Sell deals count \t\t" + "#{sell_positions.count}".bold
      puts "Profitable deals (% of all) \t" + "#{profitable_deals.count} (#{profitable_deals_percentage})".bold
      puts "Loss deals (% of all) \t\t" + "#{loss_deals.count} (#{loss_deals_percentage})".bold
      puts "Best profitable deal \t\t" + "#{best_profitable_deal.profit.format}".bold
      puts "Worst loss deal \t\t" + "#{worst_loss_deal.profit.format}".bold
      puts "Mid profit per deal \t\t" + "#{profit_per_deal.format}".bold
      puts "Mid loss per deal \t\t" + "#{loss_per_deal.format}".bold
      puts "Max continuous win (profit) \t" + "#{continuous_win[0]} (#{continuous_win[1]})".bold
      puts "Max continuous loss (profit) \t" + "#{continuous_loss[0]} (#{continuous_loss[1]})".bold
      puts "Max continuous profit and count\t" + "N/A"
      puts "Max continuous loss and count \t" + "N/A"
      puts "Mid continuous wins count \t" + "N/A"
      puts "Mid continuous loss count \t" + "N/A"
      puts "-----------------"
      puts "Deals per week\t\t\t" + "N/A"
      puts "Mid retention time \t\t" + "N/A"
      # TODO: Implement report
      # Also we need some charts:
      #   * balance history
      #   * MFE
      #   * MAE
    end
  end


end
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  setup do
    FactoryBot.create(:test_specification)
    redis.set "XAUUSD:ask:test", 20
    redis.set "XAUUSD:bid:test", 10

    @account = FactoryBot.create(:account_with_orders)

    @account_data = {
      balance: 100,
      equity: 100,
      margin: 100
    }
    @orders_data = {
      "1" => "1|buy|123|0.1|XAUUSD|2023-10-04T10:00:00Z|1.1|1.05|1.15|2023-10-05T10:00:00Z|1.12|12.0|0.1|0.01|0",
      "2" => "2|buy|345|0.1|XAUUSD|2023-09-04T10:00:00Z|1.1|1.05|1.15|2023-09-05T10:00:00Z|1.12|12.0|0.1|0.01|0"
    }
  end

  teardown do
    $redis.flushdb
  end

  # Test load_from_redis
  test "should load data from Redis" do
    redis.hmset @account.data.key, @account_data.to_a.flatten

    @account.load_from_redis
    assert_equal @account_data, {
      balance: @account[:balance],
      equity: @account[:equity],
      margin: @account[:margin]
    }
  end

  test "should load orders from Redis" do
    @account.orders.destroy_all
    redis.hmset @account.orders_data.key, @orders_data.to_a.flatten
    #
    @account.load_orders_from_redis
    assert_equal 2, @account.orders.count
  end

  test "should load data and orders from Redis" do
    mock = Minitest::Mock.new
    2.times { mock.expect :call, nil }


    @account.stub :load_from_redis, mock do
      @account.stub :load_orders_from_redis, mock do
        @account.load_data_and_orders_from_redis
      end
    end
    assert_mock mock
  end

  # Test balance calculation (using loaded orders)
  test "should calculate balance" do
    assert_equal 80_000.to_money, @account.balance
    @account.orders.destroy_all
    assert_equal 0, @account.balance
  end

  test "should calculate equity" do
    assert_equal 98_000.to_money, @account.equity
  end

  test "should calculate margin" do
    assert_equal 60_000.to_money, @account.margin
  end

  test "should calculate free margin" do
    assert_equal 38_000.to_money, @account.free_margin
  end

  test "should calculate level" do
    assert_equal 163.33.to_money, @account.level.round(2)
  end

  test "should not calculate level without orders" do
    @account.orders.destroy_all
    assert @account.level.nan?
  end

  test "should obtain starting balance" do
    assert_equal 100_000.to_money, @account.starting_balance
  end

  test "should obtain history" do
    history = %w[100000.00 110000.00 120000.00 130000.00 120000.00 110000.00 100000.00 90000.00 80000.00]
    assert_equal history, @account.history
  end

  test "should obtain history by_date" do
    history = @account.history_by_date
    assert_kind_of Time, history.first[0]
    assert_kind_of Time, history.first[1]
    assert_equal "100000.00", history.first[2]
    assert_equal "80000.00", history.last[2]
  end

  test "should calculate net profit" do
    assert_equal(-20_000.to_money, @account.net_profit)
  end

  test "should calculate total profit" do
    assert_equal 30_000.to_money, @account.total_profit
  end

  test "should calculate total loss" do
    assert_equal(-50_000.to_money, @account.total_loss)
  end

  test "should provide buy positions" do
    assert_equal 3, @account.buy_positions.count
    assert_equal "buy", @account.buy_positions[rand(3)].kind
  end

  test "should provide sell positions" do
    assert_equal 5, @account.sell_positions.count
    assert_equal "sell", @account.sell_positions[rand(5)].kind
  end

  test "should provide all deals" do
    assert_equal 8, @account.deals.count
    assert_kind_of Order, @account.deals[rand(8)]
  end

  test "should calculate profitable deals percentage" do
    assert_equal "37.5%", @account.profitable_deals_percentage
  end

  test "should calculate loss deals percentage" do
    assert_equal "62.5%", @account.loss_deals_percentage
  end

  test "should calculate best profitable deal" do
    assert_equal 10_000.to_money, @account.best_profitable_deal.profit
    assert_kind_of Order, @account.best_profitable_deal
  end

  test "should calculate worst loss deal" do
    assert_equal(-10_000.to_money, @account.worst_loss_deal.profit)
    assert_kind_of Order, @account.best_profitable_deal
  end

  test "should calculate profit per deal" do
    assert_equal 10_000.to_money, @account.profit_per_deal
  end

  test "should calculate loss per deal" do
    assert_equal(-10_000.to_money, @account.loss_per_deal)
  end

  test "should calculate continuous deals" do
    cont = [ OpenStruct.new(count: 3, sum: 30_000.to_money), OpenStruct.new(count: 5, sum: -50_000.to_money) ]
    assert_equal cont, @account.continuous
  end

  test "should calculate retention time" do
    assert_kind_of ActiveSupport::Duration, @account.mid_retention_time
  end

  test "should calcultate win expectations" do
    assert_equal(-2500.to_money, @account.win_expectation)
  end

  test "should calculate standard deviation" do
    assert_equal 10_350.98.to_money, @account.standard_deviation
  end

  test "should calculate sharpe ration" do
    assert_equal(-0.26767, @account.sharpe_ratio)
  end

  test "should calculate profit factor" do
    assert_equal 0.6, @account.profit_factor
  end

  test "should calculate recovery factor" do
    assert_equal(-0.4, @account.recovery_factor)
  end

  test "should calculate drawdowns" do
    assert_equal 1, @account.drawdowns.count
    assert_equal 50_000.to_money, @account.drawdowns.first.down
    assert_equal 20_000.to_money, @account.absolute_drawdown
    assert_equal 50_000.to_money, @account.max_drawdown
    assert_equal 38.46, @account.max_drawdown_percentage
    assert_equal 50_000.to_money, @account.relative_drawdown
    assert_equal 38.46, @account.relative_drawdown_percentage
  end

  test "should generate report" do
    String.disable_colorization = true
    assert_match(/Report on Account:\s* Test Account/, @account.report)
  end

  # # ... (similar tests for other methods that use loaded data and orders)

  # # Utility test for order parsing (you might need to adjust based on your order format)
  # test "should parse order data correctly" do
  #   order_data = "1|buy|123|0.1|EURUSD|2023-10-04T10:00:00Z|1.1|1.05|1.15|2023-10-05T10:00:00Z|1.12|12.0|0.1|0.01|0"
  #   order = @account.parse_order(order_data)
  #   assert_equal "1", order.id
  #   assert_equal "buy", order.kind
  #   assert_equal 0.1, order.lot_size
  #   # ... (other assertions for order attributes)
  # end
  private

  def redis
    $redis
  end
end

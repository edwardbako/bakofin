require "test_helper"

class TraderTest < ActiveSupport::TestCase
  setup do
    FactoryBot.create(:test_specification)
    $redis.lpush key, "2024-11-02T18:00:00+07:00|6|8|2|4|1000"
    $redis.lpush key, "2024-11-02T19:00:00+07:00|4|7|1|3|2000"
    $redis.set "XAUUSD:ask:test", 4
    $redis.set "XAUUSD:bid:test", 3


    @trader = FactoryBot.build(:trader)

    @order_mock = Minitest::Mock.new
    @order_mock.expect :attributes, true

    @orders_mock = Minitest::Mock.new
    @orders_mock.expect :count, 0
    @orders_mock.expect :create, @order_mock, [], symbol: "XAUUSD",
                                                  kind: :buy,
                                                  lot_size: 20.to_money,
                                                  open_date: Time.new("2024-11-02 19:00:00 +0700"),
                                                  open_price: 4.0,
                                                  close_price: 3.0,
                                                  stop_loss: 2.0,
                                                  take_profit: 0,
                                                  profit: 0,
                                                  swap: 0,
                                                  commission: 0,
                                                  magic_number: @trader.magic_number,
                                                  logger: @trader.logger
    @orders_mock.expect :sell, []
  end

  teardown do
    $redis.flushdb
  end

  test "constructs default settings" do
    assert_respond_to @trader, :series
    assert_respond_to @trader, :account
    assert_respond_to @trader, :magic_number
    assert_respond_to @trader, :max_load_percent
    assert_respond_to @trader, :risk_per_trade_percent
    assert_respond_to @trader, :max_opened_orders
    assert_respond_to @trader, :decrease_factor
  end

  test "on NONE signal does nothing" do
    @orders_before = @trader.send(:orders)
    @opened_before = @orders_before.opened

    @trader.trade(signal: :none)

    orders_after = @trader.send(:orders)
    opened_after = orders_after.opened

    assert_same @orders_before.count, orders_after.count
    assert_same @opened_before.count, opened_after.count
  end

  test "on OPEN_BUY opens buy orders and closes sell orders" do
    @trader.stub :orders, @orders_mock do
      @trader.trade(signal: :open_buy)
    end


    assert_mock @orders_mock
  end

  # test "on OPEN_SELL opens sell orders and closes buy orders" do
  # end

  # test "on CLOSE_BUY closes all opened buy orders" do
  # end

  # test "on CLOSE_SELL closes all opened sell orders" do
  # end

  # test "closes all opened orders" do
  # end

  private

  def key
    "series:XAUUSD:60:test:data"
  end
end

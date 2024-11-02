require "test_helper"

# == Order Test
#
class OrderTest < ActiveSupport::TestCase
  setup do
    @specification = FactoryBot.create(:specification)
    redis.set "XAUUSD:ask:test", 20
    redis.set "XAUUSD:bid:test", 10
  end

  test "should check opened" do
    order = FactoryBot.create(:opened_buy_order)
    assert order.opened?

    order = FactoryBot.create(:closed_buy_order)
    assert_not order.opened?
  end

  test "should check closed" do
    order = FactoryBot.create(:closed_buy_order)
    assert order.closed?

    order = FactoryBot.create(:opened_buy_order)
    assert_not order.closed?
  end

  test "should close order" do
    order = FactoryBot.create(:opened_buy_order)
    close_date = Time.current
    order.close price: 1, date: close_date
    assert order.closed?
    assert_equal 1.to_money, order.close_price
    assert_equal close_date, order.close_date
  end

  test "should calculate current profit" do
    order = FactoryBot.create(:closed_buy_order)
    assert_equal 10_000.to_money, order.profit
    order = FactoryBot.create(:closed_sell_order)
    assert_equal(-10_000.to_money, order.profit)
  end

  test "should calculate retention time" do
    order = FactoryBot.create(:closed_buy_order)
    date = Time.current
    order.open_date = date - 2.days
    order.close_date = date
    assert_equal 2.days, order.retention_time
  end

  test "should calculate margin" do
    order = FactoryBot.create(:opened_buy_order)
    assert_equal 10_000.to_money, order.margin
  end

  test "should retrieve orders currency" do
    order = FactoryBot.create(:closed_sell_order)
    assert_equal "USD", order.prices_currency
  end

  test "should calculate reward to risk ratio" do
    order = FactoryBot.create(:opened_sell_order)
    assert_equal 90.to_money, order.reward_to_risk_ratio
    order = FactoryBot.create(:closed_buy_order)
    assert_equal 100.to_money, order.reward_to_risk_ratio
  end

  private

  def redis
    $redis
  end
end

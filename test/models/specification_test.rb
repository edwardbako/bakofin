require "test_helper"

class SpecificationTest < ActiveSupport::TestCase
  def setup
    @specification = FactoryBot.create(:test_specification)
    @market_prices = {
      ask: 20.0,
      bid: 10.0,
      spread: 1000
    }
    $redis.set "#{@specification.symbol}:ask:test", @market_prices[:ask]
    $redis.set "#{@specification.symbol}:bid:test", @market_prices[:bid]
  end

  test "point calculation" do
    assert_equal 0.01, @specification.point
  end

  test "pips calculation" do
    assert_equal 1, @specification.pips(1)
  end

  test "getting ask price" do
    assert_equal @market_prices[:ask], @specification.ask
  end

  test "getting bid price" do
    assert_equal @market_prices[:bid], @specification.bid
  end

  test "market_prices calculation" do
    assert_equal @market_prices, @specification.market_prices
  end

  test "stoploss_cost calculation" do
    assert_equal 100, @specification.stoploss_cost(1)
  end

  test "lot_by_risk calculation" do
    assert_equal 1, @specification.lot_by_risk(100)
  end

  # Test lot_by_margin calculation
  test "lot_by_margin calculation" do
    assert_equal 0.05, @specification.lot_by_margin(100, :buy)
  end

  test "open_price_by_kind calculation" do
    assert_equal @market_prices[:ask], @specification.open_price_by_kind(:buy)
    assert_equal @market_prices[:bid], @specification.open_price_by_kind(:sell)
  end

  test "close_price_by_kind calculation" do
    assert_equal @market_prices[:bid], @specification.close_price_by_kind(:buy)
    assert_equal @market_prices[:ask], @specification.close_price_by_kind(:sell)
  end

  test "NoDataError raised when market data is missing" do
    $redis.del "#{@specification.symbol}:ask:test"
    assert_raises Specification::NoDataError do
      @specification.ask
    end
  end

  test "NoDataError raised when market data is missing symbol" do
    @specification = FactoryBot.create(:specification_with_fake_symbol)
    assert_raises Specification::NoDataError do
      @specification.ask
    end
  end
end

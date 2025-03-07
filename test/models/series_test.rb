require "test_helper"

class SeriesTest < ActiveSupport::TestCase
  setup do
    FactoryBot.create(:test_specification)
    @series = FactoryBot.build(:series)
    $redis.lpush key, "2024-11-02T18:00:00+07:00|6|8|2|4|1000"
    $redis.lpush key, "2024-11-02T19:00:00+07:00|4|7|1|3|2000"
  end

  teardown do
    $redis.flushdb
  end

  test "NoDataError raised when there is no data about quotes" do
    $redis.del key
    assert_raises Series::NoDataError do
      @series.current
    end
  end

  test "Series invalid wihtout symbol and timeframe" do
    assert_raises Series::RecordInvalid do
      FactoryBot.build(:blank_series)
    end
  end

  test "construct id for redis" do
    assert_equal "XAUUSD:60:test", @series.id
  end

  test "should load data from redis list" do
    assert_instance_of Redis::List, @series.data
  end

  test "size calculation based on data" do
    assert_respond_to @series, :size
    assert_equal 2, @series.size
  end

  test "get quote on given position" do
    assert_respond_to @series, :at
    assert_equal 6, @series[1].open
  end

  test "get current quote" do
    assert_respond_to @series, :current
    assert_respond_to @series, :last
    assert_not_nil @series.current
  end

  test "provide digits for rounding calculations" do
    assert_equal 2, @series.digits
  end

  test "get specification for symbol" do
    assert_instance_of Specification, @series.specification
  end

  test "get all quotes data" do
    assert_respond_to @series, :all
    assert_kind_of Array, @series.all
    assert_equal 2, @series.all.size
  end

  test "all elements of data are parsed as quotes" do
    @series.all.each do |quote|
      assert_instance_of Quote, quote
    end
  end

  test "defines indicators" do
    assert_respond_to @series, :iMa
    assert_kind_of Indicator, @series.iMa
  end

  private

  def key
    "series:XAUUSD:60:test:data"
  end
end

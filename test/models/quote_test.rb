require "test_helper"

# QuoteTest
class QuoteTest < ActiveSupport::TestCase
  setup do
    @quote = FactoryBot.build(:quote)
  end

  teardown do
    $redis.flushdb
  end

  test "list of attributes" do
    assert_kind_of Hash, @quote.attributes
  end

  test "calculate x value /aka time seconds integer" do
    assert_equal 1_728_057_600_000, @quote.x
  end

  test "name" do
    assert_equal "2024-10-04 19:00:00 +0300", @quote.name
  end

  test "medial price calculation" do
    assert_equal 2650.81, @quote.medial
  end

  test "typical price calculation" do
    assert_equal 2650.14, @quote.typical
  end

  test "weighted price calculation" do
    assert_equal 2649.81, @quote.weighted.round(2)
  end
end

require "test_helper"

class TestPassTest < ActiveSupport::TestCase
  def setup
    @test_pass = FactoryBot.create(:test_pass)
  end

  test '"creates new account' do
    assert @test_pass.account.present?
  end

  test "sets new account balance" do
    assert_equal @test_pass.account.balance, TestPass::STARTING_BALANCE
  end

  test "composes report about test pass" do
    String.disable_colorization = true
    assert_match(
      /Report on TestPass ##{@test_pass.id}\non symbol: #{@test_pass.symbol}, timeframe: #{@test_pass.timeframe}/,
      @test_pass.report
    )
  end
end

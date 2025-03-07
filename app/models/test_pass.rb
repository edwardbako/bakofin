# == Test Pass
#
# This is model to store information about test pass.
# Attributes:
#   * Id
#   * symbol
#   * timeframe
#   * Start Date
#   * Stop Date
#   * Strategy used
#   * Profit
#   * Log ?
class TestPass < ApplicationRecord
  include Loggable

  STARTING_BALANCE = 10_000.to_money
  has_one :account

  after_create :prepare_account

  def report
    ActiveRecord::Base.logger.silence do
      ApplicationController.render self, formats: [ :text ]
    end
  end

  private

  def prepare_account
    return if account.present?

    account = create_account(
      login: "Test account ##{id}",
      password: "test_account",
      currency: "USD",
      leverage: 1000,
      logger:
    )

    account.orders.create(
      kind: :balance,
      lot_size: 0.01,
      open_date: 50.years.ago,
      open_price: 0,
      close_date: 50.years.ago,
      close_price: STARTING_BALANCE,
      stop_loss: 0,
      take_profit: 0,
      swap: 0,
      commission: 0,
      logger:,
      profit: STARTING_BALANCE,
      test: true
    )

    logger.info(prog_name) { "Initial accout balance is #{account.balance}" }
  end
end

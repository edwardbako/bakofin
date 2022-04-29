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

  STARTING_BALANCE = Money.new 1000000
  has_one :account

  after_create :prepare_account

  def initialize(attributes = {})
    super
    @logger = attributes[:logger]
  end

  def report
    puts "Report on TestPass ##{id} on symbol: #{symbol}, timeframe: #{timeframe}"
    puts "Bars processed \t\t\t" + "#{bars_processed}".bold
    puts "---------------"
    account.report
  end

  private

  def prepare_account
    if self.account.blank?
      account = self.create_account(
        login: "Test account ##{self.id}",
        password: "test_account",
        currency: "USD",
        leverage: 1000)

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
          logger: logger,
          profit: STARTING_BALANCE
      )
      logger.info(prog_name) { "Initial accout balance is #{account.balance}"}
    end
  end
end
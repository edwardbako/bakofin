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

  STARTING_BALANCE = Money.new 1000000
  has_one :account

  after_create :prepare_account

  def report
    puts "Report on TestPass ##{id} on symbol: #{symbol}, timeframe: #{timeframe}"
    puts "Bars processed \t\t\t" + "#{bars_processed}".bold
    puts "---------------"
    account.report
  end

  private

  def prepare_account
    if self.account.blank?
      account = self.create_account(login: "Test account ##{self.id}", password: "test_account")
      account.orders.create(
          kind: :balance,
          open_date: 50.years.ago,
          close_date: 50.years.ago,
          close_price: STARTING_BALANCE
      )
    end
  end
end
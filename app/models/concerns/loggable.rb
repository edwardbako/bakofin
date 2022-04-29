module Loggable

  extend ActiveSupport::Concern

  attr_accessor :logger

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  private

  def prog_name
    self.class
  end
end
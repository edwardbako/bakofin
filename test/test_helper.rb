require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/autorun"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize_setup do |worker|
    setup_redis(worker)
  end

  parallelize_teardown do |worker|
  end

  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  include FactoryBot::Syntax::Methods
  # Add more helper methods to be used by all tests here...

  class << self
    private

    def setup_redis(db = 0)
      redis_config = YAML.load(File.open(Rails.root.join("config/redis.yml")))
      cfg = redis_config[Rails.env]
      cfg["db"] = db + 8

      $redis = Redis.new cfg
    end
  end
end

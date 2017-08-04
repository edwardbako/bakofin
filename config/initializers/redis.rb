REDIS_CONFIG = YAML.load( File.open( Rails.root.join('config/redis.yml') ) )
cfg = REDIS_CONFIG[Rails.env]

$redis = Redis.new cfg

$redis.flushdb if Rails.env.test?
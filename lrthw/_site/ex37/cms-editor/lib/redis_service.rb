# Methods for interacting with Redis
module RedisService
  def self.channel(site = 'live')
    "cms-publish-#{site}-#{Rails.env}"
  end

  def self.connection
    # default to redis defaults
    host = (ENV['REDIS_HOST'] ? ENV['REDIS_HOST'] : 'localhost')
    port = (ENV['REDIS_PORT'] ? ENV['REDIS_PORT'] : 6379)
    Redis.new(host: host, port: port)
  end
end

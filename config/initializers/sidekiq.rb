REDIS_POOL = ConnectionPool.new(size: ENV["SIDEKIQ_POOL"] || 20) do
  Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" })
end

redis_conn = proc {
  Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" })
}

Sidekiq.configure_client do |config|
  config.redis = REDIS_POOL
end

Sidekiq.configure_server do |config|
  config.redis = REDIS_POOL
end

# global msg delivery when a job dies
Sidekiq.configure_server do |config|
  config.logger.level = Logger::WARN

  config.death_handlers << lambda do |job, ex|
    msg = "Uh oh, #{job["class"]} #{job["jid"]} just died with error: #{ex.message}."
    Sidekiq.logger.warn(msg)
  end
end

Sidekiq.configure_server do |config|
  sidekiq_config = Rails.application.config_for(:sidekiq)
  config.redis = { url: "redis://#{sidekiq_config['redis_host']}:#{sidekiq_config['redis_port']}/#{sidekiq_config['redis_db']}" }
end

Sidekiq.configure_client do |config|
  sidekiq_config = Rails.application.config_for(:sidekiq)
  config.redis = { url: "redis://#{sidekiq_config['redis_host']}:#{sidekiq_config['redis_port']}/#{sidekiq_config['redis_db']}" }
end
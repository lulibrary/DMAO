$redis = Redis.new(
    host: Rails.application.config_for(:redis)["host"],
    port: Rails.application.config_for(:redis)["port"],
    db: Rails.application.config_for(:redis)["db"],
    password: Rails.application.config_for(:redis)["password"]
)
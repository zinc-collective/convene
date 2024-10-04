if ENV["REDIS_URL"]
  $redis = # rubocop:disable Style/GlobalVars
    RedisClient.new(url: ENV["REDIS_URL"],
      ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE})
end

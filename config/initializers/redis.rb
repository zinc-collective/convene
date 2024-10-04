if Rails.env.production?
  $redis = # rubocop:disable Style/GlobalVars
    Redis.new(url: ENV["REDIS_URL"],
      ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE})
end

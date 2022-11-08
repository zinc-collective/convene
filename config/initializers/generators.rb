# See: https://pawelurbanek.com/uuid-order-rails
Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
end

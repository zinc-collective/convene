# frozen_string_literal: true

class Neighborhood
  def self.config
    @config ||= Config.new
  end

  class Config
    def default_space_slug
      ENV.fetch('DEFAULT_SPACE', 'convene')
    end
  end
end

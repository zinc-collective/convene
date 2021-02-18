# frozen_string_literal: true

module Hookups
  # Inherit from this for a particular hookups configuration requirements.
  class Configuration
    # @return [Hash]
    attr_accessor :data

    include ActiveModel::Model

    def key?(name)
      data.key?(name.to_s.gsub(/=$/, ''))
    end

    def get(key)
      data[key.to_s]
    end

    def set(key, value)
      data[key.to_s] = value
    end
  end
end

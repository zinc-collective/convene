# frozen_string_literal: true

class Marketplace
  class Marketplace < FurniturePlacement
    has_many :products

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end

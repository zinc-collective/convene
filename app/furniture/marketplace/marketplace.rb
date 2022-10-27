# frozen_string_literal: true

class Marketplace
  class Marketplace < FurniturePlacement
    has_many :products, inverse_of: :marketplace
    has_many :orders, inverse_of: :marketplace

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end

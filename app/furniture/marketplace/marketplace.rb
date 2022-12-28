# frozen_string_literal: true

class Marketplace
  class Marketplace < FurniturePlacement
    self.location_parent = :room

    has_many :products, inverse_of: :marketplace, dependent: :destroy
    has_many :carts, inverse_of: :marketplace, dependent: :destroy

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end

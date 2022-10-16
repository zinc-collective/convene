# frozen_string_literal: true

class Marketplace
  class Marketplace < FurniturePlacement
    has_many :products

    def self.use_relative_model_naming?
      false
    end
  end
end
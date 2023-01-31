class Marketplace
  class Record < ApplicationRecord
    self.abstract_class = true

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end

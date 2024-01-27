class Tobias
  class Record < ApplicationRecord
    self.abstract_class = true

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Tobias)
    end
  end
end

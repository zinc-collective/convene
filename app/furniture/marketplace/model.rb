class Marketplace
  class Model
    include ActiveModel::Model
    include WithinLocation

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end

class Marketplace
  module Archivable
    def self.included(model)
      model.include(Discard::Model)
      model.alias_method :archive, :discard
      model.alias_method :archived?, :discarded?
      model.alias_method :available?, :kept?
      model.alias_method :retrieve, :undiscard

      model.scope(:archived, -> { discarded })
      model.scope(:available, -> { kept })
    end

    def destroy_safely
      destroy if destroyable?
    end

    def with_orders?
      orders.present?
    end

    def archivable?
      persisted? && available?
    end

    def destroyable?
      persisted? && archived? && !with_orders?
    end
  end
end

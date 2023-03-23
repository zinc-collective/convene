class Marketplace
  class DeliveryAreaPolicy < ApplicationPolicy
    alias_method :delivery_area, :object

    def create?
      person.operator? || person.member_of?(delivery_area.marketplace.space)
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

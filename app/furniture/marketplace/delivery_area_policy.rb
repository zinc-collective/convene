class Marketplace
  class DeliveryAreaPolicy < ApplicationPolicy
    alias_method :delivery_area, :object

    def create?
      person.operator? || person.member_of?(delivery_area.marketplace.space)
    end

    alias_method :update?, :create?

    def permitted_attributes(_)
      [:label, :price]
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

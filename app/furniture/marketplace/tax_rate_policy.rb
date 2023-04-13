class Marketplace
  class TaxRatePolicy < ApplicationPolicy
    alias_method :tax_rate, :object

    def create?
      person.operator? || person.member_of?(tax_rate.space)
    end

    alias_method :update?, :create?

    def permitted_attributes(_)
      [:label, :tax_rate]
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

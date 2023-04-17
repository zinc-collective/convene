class Space
  class AgreementPolicy < ApplicationPolicy
    alias_method :agreement, :object

    def show?
      true
    end

    def create?
      person&.operator? || person&.member_of?(agreement.space)
    end

    def permitted_attributes(_)
      %i[name body]
    end

    class Scope < ::ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

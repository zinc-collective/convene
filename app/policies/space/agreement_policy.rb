class Space
  class AgreementPolicy < ApplicationPolicy
    def show?
      true
    end

    class Scope < ::ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

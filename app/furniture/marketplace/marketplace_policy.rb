# frozen_string_literal: true

class Marketplace
  class MarketplacePolicy < ApplicationPolicy
    alias_method :marketplace, :object
    def show?
      true
    end

    def update?
      person&.member_of?(marketplace.space)
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

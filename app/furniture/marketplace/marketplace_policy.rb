# frozen_string_literal: true

class Marketplace
  class MarketplacePolicy < ApplicationPolicy
    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

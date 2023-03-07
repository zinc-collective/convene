# frozen_string_literal: true

class Marketplace
  class OrderPolicy < Policy
    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

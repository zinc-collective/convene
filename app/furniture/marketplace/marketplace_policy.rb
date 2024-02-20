# frozen_string_literal: true

class Marketplace
  class MarketplacePolicy < Policy
    alias_method :marketplace, :object
    def show?
      true
    end

    def create?
      current_person.operator? ||
        current_person.member_of?(marketplace.space) ||
        marketplace.vendor_representatives.exists?(person: current_person)
    end

    alias_method :update?, :create?

    def permitted_attributes(_)
      [:square_access_token, :square_location_id]
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

# frozen_string_literal: true

class Marketplace
  class MarketplacePolicy < Policy
    def permitted_attributes(_params)
      [:delivery_fee, :notify_emails, :delivery_window]
    end

    alias_method :marketplace, :object
    def show?
      true
    end

    def create?
      current_person.operator? || current_person.member_of?(marketplace.space)
    end

    alias_method :update?, :create?

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

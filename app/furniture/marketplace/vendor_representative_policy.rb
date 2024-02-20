# frozen_string_literal: true

class Marketplace
  class VendorRepresentativePolicy < Policy
    alias_method :vendor_representative, :object
    def permitted_attributes(_params = nil)
      %i[email_address person_id]
    end

    def update?
      return false unless current_person.authenticated?

      super
    end
    alias_method :create?, :update?

    def show?
      true
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end

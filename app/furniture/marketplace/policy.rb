class Marketplace
  class Policy < ApplicationPolicy
    def create?
      return true if current_person.operator?
      return true if current_person.member_of?(marketplace.space)

      return true if shopper&.person.blank? && !current_person.authenticated?

      return true if shopper&.person == current_person

      false
    end
    alias_method :update?, :create?

    def shopper
      return object if object.is_a?(Shopper)

      return object.shopper if object.respond_to?(:shopper)
    end

    def marketplace
      return object if object.is_a?(Marketplace)

      object.marketplace if object.respond_to?(:marketplace)
    end
  end
end

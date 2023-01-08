# frozen_string_literal: true

class Marketplace
  class CheckoutPolicy < ApplicationPolicy
    alias_method :checkout, :object

    def create?
      return true if checkout.shopper.person.blank? && !current_person.authenticated?

      checkout.shopper.person == current_person
    end

    def show?
      true
    end
  end
end

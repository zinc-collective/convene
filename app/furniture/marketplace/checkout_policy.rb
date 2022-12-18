# frozen_string_literal: true

class Marketplace
  class CheckoutPolicy < ApplicationPolicy
    alias checkout object

    def create?
      checkout.shopper.person == current_person
    end
  end
end

# frozen_string_literal: true

class Marketplace
  class ProductPolicy < ApplicationPolicy
    alias product object
    def permitted_attributes(_params = nil)
      %i[name description price_cents price_currency price]
    end

    def create?
      person.member_of?(product.space)
    end

    def update?
      create?
    end
  end
end

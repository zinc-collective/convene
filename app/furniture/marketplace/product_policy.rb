# frozen_string_literal: true
class Marketplace
  class ProductPolicy < ApplicationPolicy
    def permitted_attributes(_params)
      %i[name description price_cents price_currency]
    end
  end
end

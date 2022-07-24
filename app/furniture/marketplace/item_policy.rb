class Marketplace::ItemPolicy < ApplicationPolicy


  def permitted_attributes(_params)
    %i[product]
  end
end
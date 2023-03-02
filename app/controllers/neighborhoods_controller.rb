class NeighborhoodsController < ApplicationController
  def show
  end

  helper_method def neighborhood
    @neighborhood ||= authorize(Neighborhood.new)
  end
end

class SpacesController < ApplicationController
  def show; end

  helper_method def space
    @space ||= BrandedDomain.new(space_repository).space_for_request(request) ||
               space_repository.friendly.find(params[:id])
  end

  def space_repository
    Space.includes(:rooms, entrance: [:furniture_placements])
  end
end

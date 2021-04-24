class SpacesController < ApplicationController
  def show; end

  helper_method def space
    @space ||= BrandedDomain.new(space_repository).space_for_request(request) ||
               space_by_id
  end

  def space_by_id
    # This probably should eventually be replaced with a "default space" that serves
    # as the product's landing page
    return Space.new unless params[:id]

    space_repository.friendly.find(params[:id])
  end

  def space_repository
    Space.includes(:rooms, entrance: [:furniture_placements])
  end
end

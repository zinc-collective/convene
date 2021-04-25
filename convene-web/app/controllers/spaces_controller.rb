# frozen_string_literal: true

# Exposes CRUD actions on the {Space} model.
class SpacesController < ApplicationController
  def show; end

  def edit
  end

  helper_method def space
    @space ||= BrandedDomain.new(space_repository).space_for_request(request) ||
               space_repository.friendly.find(params[:id])

    @space.tap { authorize(@space) }
  end

  def space_repository
    Space.includes(:rooms, entrance: [:furniture_placements])
  end
end

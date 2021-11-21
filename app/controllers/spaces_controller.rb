# frozen_string_literal: true

# Exposes CRUD actions on the {Space} model.
class SpacesController < ApplicationController
  def show; end

  def edit
  end

  def create
    @space = Space.new(space_params)
    skip_policy_scope
    authorize(@space)
    Blueprint.new(client:
      { name: space_params[:name],
        space: SystemTestSpace::DEFAULT_SPACE_CONFIG.merge(space_params).with_indifferent_access

       }
      ).find_or_create!
  end

  def destroy
    space.destroy
  end

  def space_params
    params.require(:space).permit(:name)
  end

  helper_method def space
    @space ||= current_space.tap do |space|
      authorize(space)
    end
  end
end

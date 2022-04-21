# frozen_string_literal: true

# Exposes CRUD actions for {Space} Resources.
class SpacesController < ApplicationController
  def show; end

  def edit; end

  def update
    if space.update(space_params)
      flash[:notice] = t('.success')
      redirect_to space_path(space)
    else
      flash[:alert] = t('.error')
      render :edit
    end
  end

  def create
    skip_policy_scope
    client = authorize(Client.find_or_create_by(name: space_params[:name]))
    authorize(Space)
    @space = if space_params[:blueprint].present?
               Space.find_or_create_from_blueprint!(space_params.merge(client: client))
             else
               Space.create_with(space_params.merge(client: client)).find_or_create_by!(name: space_params[:name])
             end
  end

  def destroy
    space.destroy
  end

  def space_params
    policy(Space).permit(params)
  end

  helper_method def space
    @space ||= current_space.tap do |space|
      authorize(space)
    end
  end
end

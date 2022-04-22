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
    authorize(Client)
    authorize(Space)
    Space::Factory.create(space_params)
    head :created
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

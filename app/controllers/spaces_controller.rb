# frozen_string_literal: true

# Exposes CRUD actions for {Space} Resources.
class SpacesController < ApplicationController
  def show
  end

  def edit
  end

  def create
    skip_policy_scope
    authorize(Client)
    authorize(Space)

    space = Space::Factory.create(space_params)

    if space.persisted?
      render json: Space::Serializer.new(space).to_json, status: :created
    else
      render json: Space::Serializer.new(space).to_json, status: :unprocessable_entity
    end
  end

  def update
    if space.update(space_params)
      flash[:notice] = t(".success")
      redirect_to space
    else
      flash.now[:alert] = t(".error")
      render :edit
    end
  end

  delegate :destroy, to: :space

  def space_params
    policy(Space).permit(params.require(:space))
  end

  helper_method def space
    @space ||= current_space.tap do |space|
      authorize(space)
    end
  end
end

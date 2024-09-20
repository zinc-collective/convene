# frozen_string_literal: true

# Exposes CRUD actions for {Space} Resources.
class SpacesController < ApplicationController
  def show
  end

  def new
    space
  end

  def edit
  end

  def create
    skip_policy_scope
    authorize(Space)

    space = Space::Factory.create(space_params)

    if space.persisted?
      format.html do
        redirect_to space.location
      end
    else
      render :new
    end
  end

  def update
    if space.update(space_params)
      flash[:notice] = t(".success")
      redirect_to space.location(:edit), allow_other_host: true
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
    @space ||= if params[:id]
      policy_scope(Space).friendly.find(params[:id])
    elsif params[:space]
      policy_scope(Space).new(space_params)
    elsif BrandedDomainConstraint.new(space_repository).space_for_request(request).present?
      BrandedDomainConstraint.new(space_repository).space_for_request(request)
    else
      policy_scope(Space).new
    end.tap do |space|
      authorize(space)
    end
  end

  helper_method def current_space
    space.persisted? ? space : nil
  rescue Pundit::NotAuthorizedError
    @space
  end
end

# frozen_string_literal: true

class UtilitiesController < ApplicationController
  def index
    utility
  end

  def new
    utility
  end

  def edit
    utility
  end

  def create
    binding.pry
    if utility.save
      redirect_to [:edit, space]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    binding.pry
    if utility.utility.update(utility_params)
      redirect_to [:edit, space]
    else
      render :edit
    end
  end

  def destroy
    utility.destroy
    redirect_to space.location(:edit), notice: t(".success", name: utility.name, utility_type: utility.utility_slug)
  end

  helper_method def utilities
    @utilities ||= policy_scope(space.utilities).all
  end

  helper_method def utility
    return @utility if defined?(@utility)

    @utility = if params[:id]
      policy_scope(space.utilities).find(params[:id])
    else
      space.utilities.new(utility_params)
    end

    authorize(@utility) if @utility
  end

  def utility_params
    return {} unless params[:utility]
    policy(Utility).permit(params.require(:utility))
  end

  helper_method def space
    current_space
  end
end

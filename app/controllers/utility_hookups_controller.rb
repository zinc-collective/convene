# frozen_string_literal: true

class UtilityHookupsController < ApplicationController
  def index
    utility_hookup
  end

  def new
    utility_hookup
  end

  def edit
    utility_hookup
  end

  def create
    if utility_hookup.save
      redirect_to [:edit, space]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if utility_hookup.utility.update(utility_hookup_params)
      redirect_to [:edit, space]
    else
      render :edit
    end
  end

  helper_method def utility_hookups
    @utility_hookups ||= policy_scope(space.utility_hookups).all
  end

  helper_method def utility_hookup
    return @utility_hookup if defined?(@utility_hookup)

    @utility_hookup = policy_scope(space.utility_hookups).find_by(id: params[:id]) if params[:id]
    @utility_hookup ||= policy_scope(space.utility_hookups).new(utility_hookup_params)
    authorize(@utility_hookup)
  end

  def utility_hookup_params
    return {} unless params[:utility_hookup]
    policy(UtilityHookup).permit(params.require(:utility_hookup))
  end

  helper_method def space
    current_space
  end
end

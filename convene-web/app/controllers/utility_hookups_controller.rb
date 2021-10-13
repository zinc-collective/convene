# frozen_string_literal: true
class UtilityHookupsController < ApplicationController
  def edit
    utility_hookup
  end

  def index
    utility_hookup
  end

  def create
    if utility_hookup.save
      redirect_to edit_space_path(space)
    else
      render :new
    end
  end

  def update
    if utility_hookup.update(utility_hookup_params)
      redirect_to edit_space_path(space)
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
    @utility_hookup ||= space.utility_hookups.new(utility_hookup_params)
    @utility_hookup.tap { authorize(@utility_hookup) }
  end

  def utility_hookup_params
    return {} unless params[:utility_hookup]

    utility_policy = policy(Utilities.new_from_slug(params[:utility_hookup][:utility_slug]))
    params.require(:utility_hookup).permit(:name, :utility_slug, utility_attributes: utility_policy.permitted_params)
  end

  helper_method def space
    current_space
  end
end
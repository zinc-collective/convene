# frozen_string_literal: true
class UtilityHookupsController < ApplicationController
  def create
    utility_hookup.save
    redirect_to edit_space_path(space)
  end

  def update
    utility_hookup.update(utility_hookup_params)
    redirect_to edit_space_path(space)
  end

  helper_method def utility_hookup
    return @utility_hookup if defined?(@utility_hookup)

    @utility_hookup = policy_scope(UtilityHookup).find_by(id: params[:id]) if params[:id]
    @utility_hookup ||= space.utility_hookups.new(utility_hookup_params)
    @utility_hookup.tap { authorize(@utility_hookup) }
  end

  def utility_hookup_params
    utility_policy = policy(Utilities.new_from_slug(params[:utility_hookup][:utility_slug]))
    params.require(:utility_hookup).permit(:name, :utility_slug, configuration: utility_policy.permitted_params)
  end

  helper_method def space
    current_space
  end
end
class UtilityHookupsController < ApplicationController

  def create
    space.utility_hookups.create(utility_hookup_params)
    redirect_to space
  end

  def utility_hookup_params
    hookup_policy = policy(Hookups.new_from_slug(params[:utility_hookup][:utility_slug]))
    params.require(:utility_hookup).permit(:name, :utility_slug, configuration: hookup_policy.permitted_params)
  end

  helper_method def space
    current_space
  end
end
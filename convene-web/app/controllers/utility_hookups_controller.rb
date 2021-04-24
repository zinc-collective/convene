class UtilityHookupsController < ApplicationController
  def create
    utility_hookup = space.utility_hookups.new(utility_hookup_params)
    authorize(utility_hookup)
    utility_hookup.save
    redirect_to space
  end

  def utility_hookup_params
    utility_policy = policy(Hookups.new_from_slug(params[:utility_hookup][:utility_slug]))
    params.require(:utility_hookup).permit(:name, :utility_slug, configuration: utility_policy.permitted_params)
  end

  helper_method def space
    current_space
  end
end
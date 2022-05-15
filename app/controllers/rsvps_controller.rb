class RsvpsController < ApplicationController
  # Not a database-backed model, no need to policy-scope.
  skip_after_action :verify_policy_scoped

  def show
  end

  def update
    rsvp.update(rsvp_params)
  end

  def rsvp_params
    params.require(:rsvp).permit(:status, :one_time_password)
  end

  helper_method def rsvp
    @rsvp ||= Rsvp.new(invitation: invitation).tap { |rsvp| authorize(rsvp) }
  end

  helper_method def invitation
    @invitation ||= Invitation.find(params[:invitation_id])
  end
end

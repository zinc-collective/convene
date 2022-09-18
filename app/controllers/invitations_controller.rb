# frozen_string_literal: true

class InvitationsController < ApplicationController

  def index

  end

  def create
    if invitation.save
      SpaceInvitationMailer.space_invitation_email(invitation).deliver_later
      redirect_to space_memberships_path(invitation.space),
                  notice: t('.success', invitee_email: invitation.email,
                                        invitee_name: invitation.name)
    else
      redirect_to space_memberships_path(invitation.space),
                  alert: t('.failure', invitee_email: invitation.email,
                                       invitee_name: invitation.name)
    end
  end

  def destroy
    invitation.update!(status: :revoked)
    redirect_to edit_space_path(invitation.space),
                notice: t('.success', invitee_email: invitation.email,
                                      invitee_name: invitation.name)
  end

  def invitation_params
    params.require(:invitation).permit(:name, :email)
          .merge(last_sent_at: Time.zone.now, invitor: current_person)
  end

  def invitation
    @invitation ||= if params[:id]
                      authorize(invitations.find(params[:id]))
                    else
                      authorize(invitations.new(invitation_params))
                    end
  end

  helper_method def space
    current_space
  end

  helper_method def invitations
    policy_scope(current_space.invitations)
  end
end

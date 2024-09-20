# frozen_string_literal: true

class MembershipsController < ApplicationController
  def index
    skip_authorization
  end

  def show
  end

  def destroy
    if membership.revoked!
      flash.now[:notice] = t(".success")
    else
      flash.now[:alert] = t(".failure", errors: membership.errors.join(", "))
    end

    respond_to do |format|
      format.html do
        redirect_to([membership.space, :memberships])
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(membership)
      end
    end
  end

  helper_method def space
    current_space
  end

  helper_method def membership
    @membership ||= if params[:id]
      policy_scope(Membership).find(params[:id])
    else
      Membership.new(membership_params)
    end.tap do |membership|
      authorize(membership)
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:space_id, :member_id)
  end
end

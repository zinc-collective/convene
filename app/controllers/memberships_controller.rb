# frozen_string_literal: true

class MembershipsController < ApplicationController
  def create
    membership = authorize(Membership.new(membership_params))
    if membership.save
      render json: Membership::Serializer.new(membership).to_json, status: :created
    else
      render json: Membership::Serializer.new(membership).to_json, status: :unprocessable_entity
    end
  end

  def index; end

  def destroy
    membership = authorize(Membership.find(params[:id]))
    if membership.revoked!
      flash[:notice] = t('.success')
    else
      flash[:error] = t('.failure', errors: membership.errors.join(', '))
    end

    respond_to do |format|
      format.html do
        redirect_to(space_memberships_path(membership.space, membership))
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(membership)
      end
    end
  end

  helper_method def space
    current_space
  end

  private

  def membership_params
    params.require(:membership).permit(:space_id, :member_id)
  end
end

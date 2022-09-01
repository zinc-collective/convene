# frozen_string_literal: true

class SpaceMembershipsController < ApplicationController
  def create
    space_membership = authorize(SpaceMembership.new(space_membership_params))
    if space_membership.save
      render json: SpaceMembership::Serializer.new(space_membership).to_json, status: :created
    else
      render json: SpaceMembership::Serializer.new(space_membership).to_json, status: :unprocessable_entity
    end
  end

  def index; end

  def destroy
    membership = authorize(SpaceMembership.find(params[:id]))
    if membership.destroy
      flash[:notice] = t('.success')
    else
      flash[:error] = t('.failure', errors: membership.errors.join(", "))
    end

    respond_to do |format|
      format.html do
        redirect_to(space_space_memberships_path(membership.space, membership))
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

  def space_membership_params
    params.require(:space_membership).permit(:space_id, :member_id)
  end
end

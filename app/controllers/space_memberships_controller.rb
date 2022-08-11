# frozen_string_literal: true

class SpaceMembershipsController < ApplicationController
  def create
    space_membership = SpaceMembership.new(space_membership_params)
    authorize(space_membership)
    if space_membership.save
      render json: SpaceMembership::Serializer.new(space_membership).to_json, status: :created
    else
      render json: SpaceMembership::Serializer.new(space_membership).to_json, status: :unprocessable_entity
    end
  end

  def index; end

  def destroy
  end

  helper_method def space
    current_space
  end

private

  def space_membership_params
    params.require(:space_membership).permit(:space_id, :member_id)
  end
end

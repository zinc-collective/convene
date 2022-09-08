# frozen_string_literal: true

class MembershipsController < ApplicationController
  def create
    if membership.save
      render json: Membership::Serializer.new(membership).to_json, status: :created
    else
      render json: Membership::Serializer.new(membership).to_json, status: :unprocessable_entity
    end
  end

  def show; end

  def index; end

  def destroy
    if membership.revoked!
      flash[:notice] = t('.success')
    else
      flash[:error] = t('.failure', errors: membership.errors.join(', '))
    end

    respond_to do |format|
      format.html do
        redirect_to(space_memberships_path(membership.space))
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
                    end.tap(&method(:authorize))
  end

  private

  def membership_params
    params.require(:membership).permit(:space_id, :member_id)
  end
end

# frozen_string_literal: true

class PaymentForm
  class ChecksController < FurnitureController
    def create
      return if check.save

      render :new
    end

    def index; end

    private def check_params
      params.require(:payment_form_check)
            .permit(policy(checks.new).permitted_attributes)
    end

    # @returns [PaymentForm]
    helper_method def furniture
      room.furniture_placements.find_by(furniture_kind: 'payment_form').furniture
    end

    helper_method def room
      current_space.rooms.friendly.find(params[:room_id])
    end

    helper_method def space
      current_space
    end

    helper_method def check
      @check ||= checks.new(check_params)
    end

    helper_method def checks
      @checks ||= policy_scope(furniture.checks).tap do |checks|
        authorize(checks)
      end
    end
  end
end

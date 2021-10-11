# frozen_string_literal: true

module Furniture
  class CheckDropbox
    class ChecksController < FurnitureController
      def create
        @check = furniture.checks.create(check_params)
      end

      def index
      end

      private def check_params
        params.require(:check)
              .permit(:payer_name, :payer_email, :amount, :memo, :public_token)
      end

      # @returns [CheckDropbox]
      helper_method def furniture
        room.furniture_placements.find_by(furniture_kind: 'check_dropbox').furniture
      end

      helper_method def room
        current_space.rooms.friendly.find(params[:room_id])
      end

      helper_method def space
        current_space
      end

      helper_method def checks
        @checks ||= policy_scope(furniture.checks).tap do |checks|
          authorize(checks)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Furniture
  class CheckDropbox
    class ChecksController < FurnitureController
      def create
        @check = furniture.checks.create(check_params)
      end

      def index
        # TODO: Replace with proper authorization check once that's ready.
        if current_person.present? && current_person.member_of?(current_space)
          @checks = furniture.checks
        else
          @checks = []
        end
      end

      private def check_params
        params.require(:furniture_check_dropbox_check)
              .permit(:payer_name, :payer_email, :amount, :memo, :public_token)
      end

      helper_method def furniture
        room.furniture_placements.find_by(furniture_kind: "check_dropbox").furniture
      end

      helper_method def room
        current_space.rooms.friendly.find(params[:room_id])
      end

      helper_method def space
        current_space
      end
    end
  end
end

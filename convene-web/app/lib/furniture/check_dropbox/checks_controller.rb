# frozen_string_literal: true

module Furniture
  class CheckDropbox
    class ChecksController < FurnitureController
      def create
        furniture.checks.create(check_params)
      end

      private def check_params
        params.require(:furniture_check_dropbox_check)
              .permit(:payer_name, :payer_email, :amount, :memo, :public_token)
      end

      private def furniture
        room.furniture_placements.find_by(furniture_kind: "check_dropbox").furniture
      end

      private def room
        current_space.rooms.friendly.find(params[:room_id])
      end
    end
  end
end

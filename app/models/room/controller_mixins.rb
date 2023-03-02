class Room
  module ControllerMixins
    def self.included(controller)
      controller.helper_method(:room)
    end

    def room
      return @room if defined?(@room)

      @room ||= if params[:room_id]
        policy_scope(current_space.rooms).friendly.find(params[:room_id])
      end
    end
  end
end

class WaitingRoomsController < ApplicationController
  def show
  end

  def update
    if waiting_room.update(params.require(:waiting_room).permit(:access_code))
      session[:access_code] = waiting_room.access_code
      redirect_to workspace_room_path(waiting_room.workspace, waiting_room.room)
    else
      render :show
    end
  end

  helper_method def waiting_room
    @waiting_room ||= WaitingRoom.new(room: current_room)
  end
end

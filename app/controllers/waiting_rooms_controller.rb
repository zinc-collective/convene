class WaitingRoomsController < ApplicationController
  def show
    waiting_room.redirect_url = params[:redirect_url]
  end

  def update
    if waiting_room.update(params.require(:waiting_room).permit(:access_code, :redirect_url))
      session[room.id] = {access_code: waiting_room.access_code}
      redirect_to waiting_room.redirect_url
    else
      render :show, status: :unprocessable_entity
    end
  end

  helper_method def waiting_room
    @waiting_room ||= authorize(WaitingRoom.new(room: room))
  end
end

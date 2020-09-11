class RoomsController < ApplicationController
  def show
    if current_room.enterable?(params[:access_code])
      render layout: "video_room"
    else
      render 'waiting_room'
    end
  end
end

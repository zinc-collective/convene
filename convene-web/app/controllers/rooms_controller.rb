class RoomsController < ApplicationController
  before_action :set_current_room

  def show
    if @current_room.enterable?(params[:access_code])
      render layout: "video_room"
    else
      render 'waiting_room'
    end
  end

  private def set_current_room
    @current_room ||= current_workspace.rooms.friendly.find(params[:id] || params[:room_id])
  end
end

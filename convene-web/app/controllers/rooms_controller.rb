class RoomsController < ApplicationController
  before_action :set_current_room

  def waiting_room
  end

  def show
    render layout: "video_room"
  end

  private def set_current_room
    @current_room ||= current_workspace.rooms.friendly.find(params[:id] || params[:room_id])
  end
end

class RoomsController < ApplicationController
  def show
    @current_room = current_workspace.rooms.friendly.find(params[:id])
  end
end

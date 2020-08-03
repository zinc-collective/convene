class RoomsController < ApplicationController
  def show
    @room = current_workspace.rooms.friendly.find(params[:id])
  end
end
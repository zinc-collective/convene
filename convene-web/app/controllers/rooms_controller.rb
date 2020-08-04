class RoomsController < ApplicationController
  def show
    @current_room = current_workspace.rooms.friendly.accessable_by(current_person).find(params[:id])
  end
end

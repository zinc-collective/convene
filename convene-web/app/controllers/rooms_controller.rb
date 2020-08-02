class RoomsController < ApplicationController
  def show
    @workspace = current_workspace

  end

  def current_room
    @current_room ||= current_workspace.rooms.friendly.find(params[:id])
  end

  def current_workspace
    @current_workspace ||= Workspace.includes(:rooms).friendly.find(params[:workspace_id])
  end
end

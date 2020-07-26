class WorkspacesController < ApplicationController
  def show
    @rooms = current_workspace.rooms
  end

  def current_workspace
    @current_workspace ||= Workspace.friendly.find(params[:id])
  end
end
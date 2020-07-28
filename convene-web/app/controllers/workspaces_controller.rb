class WorkspacesController < ApplicationController
  def show
    @workspace = current_workspace
  end

  def current_workspace
    @current_workspace ||= Workspace.includes(:rooms).friendly.find(params[:id])
  end
end

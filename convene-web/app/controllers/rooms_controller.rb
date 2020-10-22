class RoomsController < ApplicationController
  before_action :authorize

  def show
  end

  def edit
  end

  def update
    if room.update(room_params)
      redirect_to workspace_path(room.workspace)
    else
      render :edit
    end
  end

  def room_params
    params.require(:room).permit(:access_level, :access_code)
  end

  helper_method def page_title
    "#{current_workspace.name} - #{current_room.name}"
  end

  helper_method def room
    current_room
  end

  private def authorize
    if !room.enterable?(current_access_code(room))
      redirect_to workspace_room_waiting_room_path(current_workspace, current_room, redirect_url: after_authorization_redirect_url)
    end
  end

  private def after_authorization_redirect_url
    return edit_workspace_room_path(room.workspace, room) if [:edit, :update].include?(action_name)
    workspace_room_path(room.workspace, room)
  end
end

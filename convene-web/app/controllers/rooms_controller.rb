class RoomsController < ApplicationController
  def show
    if current_room.enterable?(session[:access_code])
      render :show
    else
      redirect_to workspace_room_waiting_room_path(current_workspace, current_room)
    end
  end

  helper_method def page_title
    "#{current_workspace.name} - #{current_room.name}"
  end
end

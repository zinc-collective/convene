class RoomsController < ApplicationController
  def show
    if room.enterable?(session[:access_code])
      render :show
    else
      redirect_to workspace_room_waiting_room_path(current_workspace, current_room)
    end
  end

  def edit

  end


  def update
    if room.update(room_params)
      redirect_to workspace_room_path(room.workspace, room)
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
end

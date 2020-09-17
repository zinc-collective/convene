class RoomsController < ApplicationController
  def show
    if current_room.enterable?(params[:access_code])
      render :show
    else
      render :waiting_room
    end
  end

  helper_method def page_title
    "#{current_workspace.name} - #{current_room.name}"
  end
end

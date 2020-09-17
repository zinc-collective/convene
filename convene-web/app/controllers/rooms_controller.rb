class RoomsController < ApplicationController
  def show
    if current_room.enterable?(params[:access_code])
      render :show
    else
      render :waiting_room
    end
  end
end

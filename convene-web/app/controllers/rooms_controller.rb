class RoomsController < ApplicationController
  before_action :check_access_code

  def show
  end

  def edit
  end

  def new
    authorize(room)
  end

  def create
    authorize(room)
    if room.save
      flash[:notice] = t('.success', room_name: room.name)
      redirect_to edit_space_room_path(room.space, room)
    else
      render :new
    end
  end

  def update
    if room.update(room_params)
      redirect_to space_path(room.space)
    else
      render :edit
    end
  end

  def room_params
    return {} unless params.key?(:room)

    params.require(:room).permit(:access_level, :access_code, :name, :slug, :publicity_level)
  end

  helper_method def page_title
    ["[Convene]", current_room&.name, current_space&.name].compact.join(" - ")
  end

  helper_method def room
    @room ||= current_room || current_space.rooms.new(room_params)
  end

  # TODO: Unit test authorize and redirect url
  private def check_access_code
    return unless room.persisted?

    authorize(room)
    if !room.enterable?(current_access_code(room))
      redirect_to space_room_waiting_room_path(current_space, current_room, redirect_url: after_authorization_redirect_url)
    end
  end

  # TODO: Unit test authorize and redirect url
  private def after_authorization_redirect_url
    return edit_space_room_path(room.space, room) if [:edit, :update].include?(action_name.to_sym)
    space_room_path(room.space, room)
  end
end

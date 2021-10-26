class RoomsController < ApplicationController
  before_action :check_access_code

  def show
  end

  def edit
  end

  def new

  end

  def create
    if room.save
      flash[:notice] = t('.success', room_name: room.name)
      redirect_to edit_space_room_path(room.space, room)
    else
      render :new
    end
  end

  def update
    if room.update(room_params)
      redirect_to edit_space_path(room.space), notice: t('.success', room_name: room.name)
    else
      render :edit
    end
  end

  def destroy
    if room.destroy
      redirect_to edit_space_path(room.space), notice: t('.success', room_name: room.name)
    else
      flash[:alert] = t('.failure', room_name: room.name)
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
    @room ||= (current_room || current_space.rooms.new(room_params)).tap do |room|
      authorize(room)
    end
  end

  # TODO: Unit test authorize and redirect url
  private def check_access_code
    return unless room.persisted?

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

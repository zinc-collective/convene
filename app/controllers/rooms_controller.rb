# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :check_access_code

  def show
    respond_to do |format|
      format.html
      format.json { render json: Room::Serializer.new(room).to_json }
    end
  end

  def new
  end

  def edit
  end

  def create
    if room.save
      flash[:notice] = t(".success", room_name: room.name)
      redirect_to [:edit, room.space, room]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if room.update(room_params)
        format.html do
          redirect_to [:edit, room.space], notice: t(".success", room_name: room.name)
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end

      format.json { render json: Room::Serializer.new(room).to_json }
    end
  end

  def destroy
    if room.destroy
      redirect_to [:edit, room.space], notice: t(".success", room_name: room.name)
    else
      flash.now[:alert] = t(".failure", room_name: room.name)
      render :edit
    end
  end

  def room_params
    return {} unless params.key?(:room)

    policy(Room).permit(params.require(:room))
  end

  helper_method def page_title
    ["[Convene]", room&.name, current_space&.name].compact.join(" - ")
  end

  helper_method def room
    @room ||= if params[:id]
      current_space.rooms.friendly.find(params[:id])
    else
      current_space.rooms.new(room_params)
    end.tap do |room|
      authorize(room)
    end
  end

  # TODO: Unit test authorize and redirect url
  private def check_access_code
    return unless room.persisted?

    unless room.enterable?(current_access_code(room))
      redirect_to [current_space, room, :waiting_room, redirect_url: after_authorization_redirect_url]
    end
  end

  # TODO: Unit test authorize and redirect url
  private def after_authorization_redirect_url
    if %i[edit update].include?(action_name.to_sym)
      return url_for([:edit, room.space, room])
    end

    url_for([room.space, room])
  end
end

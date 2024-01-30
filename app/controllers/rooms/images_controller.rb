class Rooms::ImagesController < ApplicationController
  def create
    new_media = Media.create
    new_media.upload.attach(params[:hero_image_upload])

    if room.update({hero_image: new_media})
      flash[:notice] = t(".success", room_name: room.name)
      redirect_to [:edit, room.space, room]
    else
      flash[:notice] = t(".failure", room_name: room.name)
      render :new, status: :unprocessable_entity
    end
  end

  helper_method def room
    @room ||= if params[:room_id]
      current_space.rooms.friendly.find(params[:room_id])
    else
      # TODO error
    end.tap do |room|
      authorize(room)
    end
  end
end

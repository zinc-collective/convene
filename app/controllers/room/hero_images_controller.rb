class Room
  class HeroImagesController < ApplicationController
    def create
      old_hero_image = room.hero_image
      new_media = Media.create
      new_media.upload.attach(media_params[:upload])

      if room.update(hero_image: new_media)
        old_hero_image&.destroy
        flash[:notice] = t(".success", room_name: room.name)
        redirect_to [:edit, room.space, room]
      else
        flash[:notice] = t(".failure", room_name: room.name)
        render :new, status: :unprocessable_entity
      end
    end

    def media_params
      params.require(:media).permit(:upload)
    end

    helper_method def room
      @room ||= authorize(policy_scope(Room).friendly.find(params[:room_id]))
    end
  end
end

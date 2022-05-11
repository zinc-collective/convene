# frozen_string_literal: true

class EmbeddedImage
  class ImageFilesController < FurnitureController
    def create
      if image_file.update(image_file_params)
        flash[:success] = "BOOM"
      else
        flash[:error] = "WOMP"
      end

      redirect_to [space, room]
    end

    def update
      if image_file.update(image_file_params)
        flash[:success] = "BOOM"
      else
        flash[:error] = "WOMP"
      end

      redirect_to [space, room]
    end

    private def image_file_params
      policy(image_file).permit(params.require(:embedded_image_image_file))
    end

    helper_method def embedded_image
      room.furniture_placements.find_by(furniture_kind: 'embedded_image').furniture
    end

    helper_method def image_file
      @image_file ||= authorize policy_scope(embedded_image.image_file)
    end
  end
end

# frozen_string_literal: true

class Spotlight
  class ImageFilesController < FurnitureController
    def create
      if image_file.update(image_file_params)
        flash[:notice] = t('.success')
      else
        flash[:alert] = t('.failure')
      end

      redirect_to [space, room]
    end

    def edit ; end

    def update
      if image_file.update(image_file_params)
        flash[:notice] = t('.success')
      else
        flash[:alert] = t('.failure')
      end

      redirect_to [space, room]
    end

    private def image_file_params
      policy(image_file).permit(params.require(:spotlight_image_file))
    end

    helper_method def spotlight
      furniture_placement.furniture
    end

    helper_method def furniture_placement
      @furniture_placement ||= room.furniture_placements.find_by(furniture_kind: 'spotlight')
    end

    helper_method def image_file
      @image_file ||= authorize spotlight.image_file
    end
  end
end

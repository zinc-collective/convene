# frozen_string_literal: true

class Spotlight
  class ImagesController < FurnitureController
    def create
      if image.update(image_params)
        flash[:notice] = t('.success')
      else
        flash[:alert] = t('.failure')
      end

      redirect_to [space, room]
    end

    def edit ; end

    def update
      if image.update(image_params)
        flash[:notice] = t('.success')
      else
        flash[:alert] = t('.failure')
      end

      redirect_to [space, room]
    end

    private def image_params
      policy(image).permit(params.require(:spotlight_image))
    end

    helper_method def spotlight
      furniture_placement.furniture
    end

    helper_method def furniture_placement
      @furniture_placement ||= room.furniture_placements.find_by(furniture_kind: 'spotlight')
    end

    helper_method def image
      @image ||= authorize spotlight.image
    end
  end
end

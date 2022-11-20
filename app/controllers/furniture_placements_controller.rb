class FurniturePlacementsController < ApplicationController
  def create
    respond_to do |format|
      if furniture_placement.save!
        format.html do
          redirect_to(
            space_room_path(furniture_placement.room.space, furniture_placement.room),
            notice: t(".success", name: furniture_placement.furniture.model_name.human)
          )
        end
        format.turbo_stream
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    respond_to do |format|
      if furniture_placement.update!(furniture_placement_params)
        format.html do
          redirect_to(
            space_room_path(furniture_placement.room.space, furniture_placement.room),
            notice: t(".success", name: furniture_placement.furniture.model_name.human)
          )
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(furniture_placement)
        end
      end
    end
  end

  def destroy
    furniture_placement.destroy!
    respond_to do |format|
      format.html do
        redirect_to(
          space_room_path(furniture_placement.room.space, furniture_placement.room),
          notice: t(".success", name: furniture_placement.furniture.model_name.human.titleize)
        )
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(furniture_placement)
      end
    end
  end

  helper_method def furniture_placement
    @furniture_placement ||= find_or_build.tap do |furniture_placement|
      authorize(furniture_placement)
    end
  end

  def find_or_build
    return current_room.furniture_placements.find(params[:id]) if params[:id]

    current_room.furniture_placements.new(furniture_placement_params)
  end

  def furniture_placement_params
    policy(FurniturePlacement).permit(params.require(:furniture_placement))
  end
end

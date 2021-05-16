class FurniturePlacementsController < ApplicationController
  def update
    authorize(furniture_placement)

    furniture_placement.update(furniture_placement_params)
    flash[:notice] = "Updated #{furniture_placement.furniture.model_name.human.titleize}"

    redirect_to edit_space_room_path(furniture_placement.room.space, furniture_placement.room)
  end

  def furniture_placement
    @furniture_placement ||= FurniturePlacement.find(params[:id])
  end

  def furniture_placement_params
    params.require(:furniture_placement).permit(:furniture_kind, :slot,
      furniture_attributes: furniture_params)
  end

  def furniture_params
    furniture_placement.furniture.attribute_names
  end
end

class FurniturePlacementsController < ApplicationController
  def update
    furniture_placement.update(furniture_placement_params)
    flash[:notice] = "Updated #{furniture_placement.furniture.model_name.human.titleize}"

    redirect_to edit_space_room_path(furniture_placement.room.space, furniture_placement.room)
  end

  def create
    furniture_placement.save!
    redirect_to edit_space_room_path(furniture_placement.room.space, furniture_placement.room)
  end

  def furniture_placement
    @furniture_placement ||= find_or_build.tap do |furniture_placement|
      authorize(furniture_placement)
    end
  end

  def find_or_build
    return current_room.furniture_placements.find(params[:id]) if params[:id]

    current_room.furniture_placements.new(furniture_placement_params)
  end

  def furniture_placement_params
    params.require(:furniture_placement).permit(:furniture_kind, :slot,
      furniture_attributes: furniture_params)
  end

  def furniture_params
    Furniture::REGISTRY.each_value.reduce([]) do |m, v|
      m.concat(v.new.attribute_names)
    end
  end
end

class FurniturePlacementsController < ApplicationController
  def update
    furniture_placement.update(furniture_placement_params)
    flash[:notice] = "Updated #{furniture_placement.furniture.model_name.human.titleize}"

    redirect_to edit_space_room_path(furniture_placement.room.space, furniture_placement.room)
  end

  def furniture_placement
    @furniture_placement ||= policy_scope(FurniturePlacement).find_by(id: params[:id])
    @furniture_placement ||= current_room.furniture_placements.new(furniture_placement_params)
    @furniture_placement.tap { |fp| authorize(fp) }
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

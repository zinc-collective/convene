class FurniturePlacementsController < ApplicationController
  def update
    furniture_placement.update!(furniture_placement_params)
    redirect_to(
      edit_space_room_path(furniture_placement.room.space, furniture_placement.room),
      notice: t('.success', name: furniture_placement.furniture.model_name.human )
    )
  end

  def create
    furniture_placement.save!
    redirect_to(
      edit_space_room_path(furniture_placement.room.space, furniture_placement.room),
      notice: t('.success', name: furniture_placement.furniture.model_name.human.titleize )
    )
  end

  def destroy
    furniture_placement.destroy!
    redirect_to(
      edit_space_room_path(furniture_placement.room.space, furniture_placement.room),
      notice: t('.success', name: furniture_placement.furniture.model_name.human.titleize)
    )
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
    policy(FurniturePlacement).permit(params.require(:furniture_placement))
  end
end

class FurnituresController < ApplicationController
  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    respond_to do |format|
      if furniture.save!
        format.html do
          redirect_to(
            [furniture.room.space, furniture.room],
            notice: t(".success", name: furniture.furniture.model_name.human)
          )
        end
        format.turbo_stream
      end
    end
  end

  def update
    respond_to do |format|
      if furniture.update!(furniture_params)
        format.html do
          redirect_to(
            [:edit, furniture.room.space, furniture.room],
            notice: t(".success", name: furniture.furniture.model_name.human)
          )
        end
      end
    end
  end

  def destroy
    furniture.furniture.destroy!
    respond_to do |format|
      format.html do
        redirect_to(
          [furniture.room.space, furniture.room],
          notice: t(".success", name: furniture.furniture.model_name.human.titleize)
        )
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(furniture)
      end
    end
  end

  helper_method def furniture
    @furniture ||= find_or_build.tap do |furniture|
      authorize(furniture)
    end
  end

  def find_or_build
    return current_room.furnitures.find(params[:id]) if params[:id]

    current_room.furnitures.new(furniture_params)
  end

  def furniture_params
    policy(Furniture).permit(params.require(:furniture))
  end
end

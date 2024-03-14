class SlotsController < ApplicationController
  expose :slot, scope: -> { policy_scope(current_room.slots) }

  def new
    authorize(slot)
  end

  def create
    if authorize(slot).save
      redirect_to(slot.slottable.location)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def slot_params
    params.require(:slot).permit([:slottable_type])
  end
end

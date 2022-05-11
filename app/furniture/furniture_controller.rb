# frozen_string_literal: true

class FurnitureController < ::ApplicationController
  helper_method def room
    current_space.rooms.friendly.find(params[:room_id])
  end

  helper_method def space
    current_space
  end
end

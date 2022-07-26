# frozen_string_literal: true

class FurnitureController < ::ApplicationController
  helper_method def room
    current_space.rooms.friendly.find(params[:room_id])
  end

  helper_method def space
    current_space
  end

  def dom_id(record)
    record_identifier.dom_id(record)
  end

  def record_identifier
    @record_identifier ||= ActionView::RecordIdentifier
  end
end

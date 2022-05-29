# frozen_string_literal: true

class VideoBridgeWithTables
  class TablesController < FurnitureController
    def page_title
      "#{room.space.name}, #{room.name}, #{table.name}"
    end

    def show; end

    helper_method def table
      @table ||= furniture_placement&.furniture&.find_table(params[:id])
    end

    helper_method def furniture_placement
      @furniture_placement ||= room.furniture_placements.find_by!(furniture_kind: :video_bridge_with_tables)
    end

    helper_method def room
      @room ||= current_space.rooms.friendly.find(params[:room_id])
    end
  end
end

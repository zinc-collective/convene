module Furniture
  class BreakoutTablesByJitsi
    class Controller < Furniture::FurnitureController
      def page_title
        "#{room.space.name}, #{room.name}, #{table.name}"
      end

      def show; end

      helper_method def table
        @table ||= room.furniture_placements.find_by!(name: :breakout_tables_by_jitsi)
          &.furniture&.find_table(params[:id])
      end

      helper_method def room
        @room ||= current_space.rooms.friendly.find(params[:room_id])
      end
    end
  end
end
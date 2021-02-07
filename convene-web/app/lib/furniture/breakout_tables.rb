module Furniture
  class BaseController < ::ApplicationController
  end

  class BreakoutTables
    attr_accessor :placement

    delegate :settings, to: :placement

    def initialize(placement)
      self.placement = placement
    end

    def in_room_template
      'furniture/breakout_tables/in_room'
    end

    def find_table(table_name)
      tables.find { |table| table.name == table_name }
    end

    def tables
      settings['names'].lazy.map do |name|
        Table.new(name: name, placement: placement)
      end
    end

    class Controller < Furniture::BaseController
      def page_title
        "#{room.space.name}, #{room.name}, #{table.name}"
      end

      helper_method def table
        @table ||= room.furniture_placements.find_by!(name: :breakout_tables)
          &.furniture&.find_table(params[:id])
      end

      helper_method def room
        @room ||= current_space.rooms.friendly.find(params[:room_id])
      end
    end

    class Table
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, :string

      # @return [FurniturePlacement]
      attr_accessor :placement

      delegate :room, :space, to: :placement
      delegate :video_host, to: :room

      def full_slug
        "#{room.full_slug}--#{slug}"
      end

      def slug
        name.parameterize
      end

      def id
        slug
      end

      def persisted?
        true
      end
    end
  end
end

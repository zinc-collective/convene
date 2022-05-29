# frozen_string_literal: true

class VideoBridgeWithTables
  def self.append_routes(router)
    router.scope module: :video_bridge_with_tables do
      router.resources :tables, only: [:show]
    end
  end
  include Placeable

  def find_table(table_name)
    tables.find { |table| table.name == table_name }
  end

  def tables
    settings.fetch('names', []).lazy.map do |name|
      Table.new(name: name, placement: placement)
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
# frozen_string_literal: true

class BreakoutTablesByJitsi
  def self.deprecated_append_routes(router)
    router.resources :breakout_tables_by_jitsi, only: [:show], controller: 'breakout_tables_by_jitsi_by_jitsi/'
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
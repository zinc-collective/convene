# {Furniture} is placed in a {Room} so that it may be used by the folks who are
# in the {Room}.
#
# {Furniture} is configured using the {#settings} attribute, which is structured
# as JSON, so that {Furniture} can be tweaked and configured as appropriate for
# it's particular use case.
class Furniture < ApplicationRecord
  include RankedModel
  include WithinLocation
  self.location_parent = :room

  ranks :slot, with_same: [:room_id]

  belongs_to :room
  delegate :space, to: :room

  attribute :furniture_kind, :string

  attribute :settings, :json, default: -> { {} }

  # The order in which {Furniture} is rendered in a Room. Lower is higher.
  attribute :slot, :integer

  delegate :attributes=, to: :furniture, prefix: true

  def furniture
    @furniture ||= Furniture.from_placement(self)
  end

  def title
    furniture.model_name.human.titleize
  end

  delegate :utilities, to: :space

  def form_template
    "furnitures/noop"
  end

  def configurable?
    furniture.form_template != "furnitures/noop"
  end

  # @returns true if this Furniture kind has its own controller with an :edit action
  def has_controller_edit?
    false
  end

  def write_attribute(name, value)
    super
  rescue ActiveModel::MissingAttributeError => _e
    settings[name] = value
  end

  def self.router
    return const_get(:Routes) if const_defined?(:Routes)
    return class_name.constantize.const_get(:Routes) if class_name.constantize.const_defined?(:Routes)
  end

  def self.registry
    @registry ||= {
      journal: ::Journal::Journal,
      markdown_text_block: ::MarkdownTextBlock,
      marketplace: ::Marketplace::Marketplace,
      livestream: ::Livestream,
      embedded_form: EmbeddedForm
    }
  end

  # Appends each Furnitures CRUD actions within the {Room}
  def self.append_routes(router)
    registry.each_value do |furniture|
      furniture.router&.append_routes(router)
    end
  end

  # @return [Furniture]
  def self.from_placement(placement)
    furniture_class = registry.fetch(placement.furniture_kind.to_sym)
    placement.becomes(furniture_class)
  end

  def to_kind_class
    becomes(Furniture.registry.fetch(furniture_kind.to_sym))
  end

  # Adds a writer and a reader for a value backed by `settings`
  def self.settings_attribute(setting_name)
    define_method(setting_name.to_s) do
      settings[setting_name.to_s]
    end

    define_method("#{setting_name}=") do |value|
      settings[setting_name.to_s] = value
    end
  end
end

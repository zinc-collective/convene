# {Furniture} is placed in a {Room} so that it may be used by the folks who are
# in the {Room}.
#
# {Furniture} is configured using the {#settings} attribute, which is structured
# as JSON, so that {Furniture} can be tweaked and configured as appropriate for
# it's particular use case.
class Furniture < ApplicationRecord
  location(parent: :room)

  include RankedModel
  ranks :slot, with_same: [:room_id]

  belongs_to :room, inverse_of: :gizmos
  has_one :space, through: :room, inverse_of: :gizmos

  attribute :furniture_kind, :string

  attribute :settings, :json, default: -> { {} }

  # The order in which {Furniture} is rendered in a Room. Lower is higher.
  attribute :slot, :integer

  delegate :attributes=, to: :gizmo, prefix: true

  validates :furniture_kind, presence: true

  # Used by child classes that require storage of secrets, like Square API keys
  # for a Marketplace
  has_encrypted :secrets, type: :json

  # Setting `secrets` to an empty hash after initialization will force consistent access for developers, rather than having to code around a potential nil value
  after_initialize do
    # The `RankedModel` gem uses
    #   [`ActiveRecord::QueryMethods.select`](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-select)
    # to do some stuff (Validation?) under the covers while keeping memory usage light... Which is good!
    # But it also means that we don't have the ciphertext!
    # So we can't set the secrets in that case (nor would we want to)
    self.secrets ||= {} if has_attribute?("secrets_ciphertext")
  end

  def gizmo
    @gizmo ||= Furniture.from_placement(self)
  end
  alias_method :furniture, :gizmo

  def title
    gizmo.model_name.human.titleize
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

  # Adds a writer and a reader for a value backed by `settings`
  def self.setting(setting_name, options = {})
    setting_name_str = setting_name.to_s
    default = options.fetch(:default, nil)

    define_method(setting_name_str) do
      settings.fetch(setting_name_str, default)
    end

    define_method("#{setting_name_str}=") do |value|
      settings[setting_name_str] = value
    end
  end

  # Makes it possible to do Rails-y things like:
  #   furniture.update(some_settings_field)
  def write_attribute(name, value)
    super
  rescue ActiveModel::MissingAttributeError => _e
    settings[name] = value
  end

  def self.router
    return const_get(:Routes) if const_defined?(:Routes)
    class_name.constantize.const_get(:Routes) if class_name.constantize.const_defined?(:Routes)
  end

  def self.registry
    @registry ||= {
      journal: ::Journal::Journal,
      markdown_text_block: ::MarkdownTextBlock,
      marketplace: ::Marketplace::Marketplace,
      livestream: ::Livestream,
      section_navigation: SectionNavigation::SectionNavigation,
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
end

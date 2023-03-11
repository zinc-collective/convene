# frozen_string_literal: true

# Links a {Utility} to a {Space}
class UtilityHookup < ApplicationRecord
  # @return [Space]
  belongs_to :space
  self.location_parent = :space

  # Human-friendly name for disambiguating when a particular kind of {Hookup}
  # has multiple {UtilityHookup}s.
  # @return [String]
  attribute :name, :string
  validates :name, presence: true, uniqueness: {scope: :space_id}

  def name
    self[:name] ||= utility_slug.to_s.humanize
  end

  # Which type of {Utility} is connected
  # @return [String]
  attribute :utility_slug, :string
  validates :utility_slug, presence: true

  # @return [String]
  attribute :status, :string, default: "unavailable"
  validates :status, presence: true, inclusion: {in: %w[ready unavailable]}

  has_encrypted :configuration, type: :json

  after_initialize do
    self.configuration ||= {}
  end

  # @return [Utility]
  def utility
    becomes(UtilityHookup.fetch(utility_slug))
  end

  def utility_attributes=(attributes)
    self.configuration ||= {}
    utility.attributes = attributes
  end

  def form_template
    "#{self.class.name.demodulize.underscore.pluralize}/form"
  end

  def has_form?
    form_template != utility.form_template
  end

  def display_name
    model_name.human.titleize
  end

  def self.registry
    @registry ||= {
      stripe: StripeUtility
    }
  end

  def self.fetch(slug)
    registry.fetch(slug&.to_sym, UtilityHookup)
  end
end

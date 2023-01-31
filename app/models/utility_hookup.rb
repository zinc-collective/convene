# frozen_string_literal: true

# Links a {Utility} to a {Space}
class UtilityHookup < ApplicationRecord
  # @return [Space]
  belongs_to :space

  # Human-friendly name for disambiguating when a particular kind of {Hookup}
  # has multiple {UtilityHookup}s.
  # @return [String]
  attribute :name, :string
  validates :name, presence: true, uniqueness: {scope: :space_id}

  def name
    self[:name] ||= utility_slug.to_s.humanize
  end

  # Which type of {Utility} is connected
  # Should match one of the keys in {Utilities::REGISTRY}
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
    @utility ||= Utilities.from_utility_hookup(self)
  end

  def utility_attributes=(attributes)
    self.configuration ||= {}
    utility.attributes = attributes
  end

  def self.from_utility_hookup(utility_hookup)
    utility_hookup.becomes(self)
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
end

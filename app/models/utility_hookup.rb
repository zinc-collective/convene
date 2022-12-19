# frozen_string_literal: true

# Links a {Utility} to a {Space}
class UtilityHookup < ApplicationRecord
  # @return [Space]
  belongs_to :space

  # Human-friendly name for disambiguating when a particular kind of {Hookup}
  # has multiple {UtilityHookup}s.
  # @return [String]
  attribute :name, :string
  validates :name, presence: :true, uniqueness: { scope: :space_id }

  def name
    attributes[:name] ||= utility_slug.to_s.humanize
  end

  # Which type of {Utility} is connected
  # Should match one of the keys in {Utilities::REGISTRY}
  # @return [String]
  attribute :utility_slug, :string
  validates :utility_slug, presence: true

  # @return [String]
  attribute :status, :string, default: "unavailable"
  validates :status, presence: true, inclusion: {in: %w[ready unavailable]}

  # validates_associated :utility
  has_encrypted :configuration, type: :json

  after_initialize do
    self.configuration ||= {}
  end

  # @todo How could we streamline this without too much metaprogramming?
  def self.plaid
    where(utility_slug: "plaid").first&.utility
  end

  # @return [Utility]
  def utility
    @utility ||= Utilities.from_utility_hookup(self)
  end

  def utility_attributes=(attributes)
    self.configuration ||= {}
    utility.attributes = attributes
  end

  def display_name
    model_name.human.titleize
  end

  def form_template
    "#{self.class.name.demodulize.underscore}/form"
  end

  def self.from_utility_hookup(utility_hookup)
    utility_hookup.becomes(self)
  end

  def polymorph
    x = Utilities::REGISTRY.fetch(utility_slug&.to_sym, NullUtility)
    x.ancestors.include?(UtilityHookup) ? becomes(x) : self
  end
end

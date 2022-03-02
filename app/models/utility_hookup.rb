# frozen_string_literal: true

# Links a {Utility} to a {Space}
class UtilityHookup < ApplicationRecord
  # @return [Space]
  belongs_to :space

  # Human-friendly name for disambiguating when a particular kind of {Hookup}
  # has multiple {UtilityHookup}s.
  # @return [String]
  attribute :name, :string

  def name
    attributes[:name] ||= utility_slug.to_s.humanize
  end

  # Which type of {Utility} is connected
  # Should match one of the keys in {Utilities::REGISTRY}
  # @return [String]
  attribute :utility_slug, :string
  validates :utility_slug, presence: true

  # @return [String]
  attribute :status, :string, default: 'unavailable'
  validates :status, presence: true, inclusion: { in: %w[ready unavailable] }

  attribute :old_configuration, :json, default: {}
  validates_associated :utility
  lockbox_encrypts :configuration, type: :json

  after_initialize do
    self.configuration ||= {}
  end

  # @todo How could we streamline this without too much metaprogramming?
  def self.plaid
    where(utility_slug: 'plaid').first&.utility
  end

  # @return [Utility]
  def utility
    @utility ||= Utilities.from_utility_hookup(self)
  end

  def utility_attributes=(attributes)
    self.configuration ||= {}
    utility.attributes = attributes
  end
end

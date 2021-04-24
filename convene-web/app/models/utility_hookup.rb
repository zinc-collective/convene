# frozen_string_literal: true

# Links a {Hookups::Hookup} to a {Space}
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

  # Which type of {Hookups::Hookup} is connected
  # Should match one of the keys in {Hookups::REGISTRY}
  # @return [String]
  attribute :utility_slug, :string

  # @return [String]
  attribute :status, :string, default: 'unavailable'
  validates :status, presence: true, inclusion: { in: %w[ready unavailable] }

  attribute :configuration, :json, default: {}

  # @return [Hookups::Hookup]
  def hookup
    @hookup ||= Hookups.from_utility_hookup(self)
  end
end

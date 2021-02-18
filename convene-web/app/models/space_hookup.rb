# frozen_string_literal: true

# Links a {Hookups::Hookup} to a {Space}
class SpaceHookup < ApplicationRecord
  # Which Space the Hookup is connected to.
  # @return [Space]
  belongs_to :space

  # Human-friendly name for disambiguating when a single kind of Hookup has
  # multiple {SpaceHookup}s.
  # @return [String]
  attribute :name, :string

  def name
    attributes[:name] ||= hookup_slug.to_s.humanize
  end

  # Which type of {Hookups::Hookup} is connected
  # Should match one of the keys in {Hookups::REGISTRY}
  # @return [String]
  attribute :hookup_slug, :string

  # @return [String]
  attribute :status, :string, default: 'unavailable'
  validates :status, presence: true, inclusion: { in: ['ready', 'unavailable'] }

  attribute :configuration, :json, default: {}

  # @return [Hookups::Hookup]
  def hookup
    @hookup ||= Hookups.from_space_hookup(self)
  end
end

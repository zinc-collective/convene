# frozen_string_literal: true

# A Space is a collection of infrastructure resources
# for collaboration
class Space < ApplicationRecord
  # Which client owns the space
  belongs_to :client

  # The fully-qualified domain to enter the space.
  # Spaces without a branded_domain are still accessible via their slug.
  # The branded_domain must be unique to ensure we don't accidentally place
  # a visitor into the wrong space.
  attribute :branded_domain, :string
  validates :branded_domain, uniqueness: true, allow_nil: true

  # The human-friendly name for the space
  attribute :name, :string
  validates :name, presence: true, uniqueness: true

  # The URI-friendly name for the space
  attribute :slug, :string
  validates :slug, uniqueness: true

  # FriendlyId's does the legwork to make the slug uri-friendly
  extend FriendlyId

  friendly_id :name, use: :slugged

  # Joins People to spaces for permissioning and
  # other purposes
  has_many :space_memberships, inverse_of: :space

  # The People with permissions for the Space
  has_many :members, through: :space_memberships

  # The Rooms within this Space
  has_many :rooms, inverse_of: :space

  belongs_to :entrance, class_name: 'Room', optional: true

  # A Space's Access Level indicates what a participant must know in order to gain access.
  # `unlocked` The participant does not need to know anything to gain access.
  # `locked` Participants must know the Space's `access_code` to gain access.
  attribute :access_level, :string

  # A room's Access Code is a "secret" that, when known, grants access to the room.
  attribute :access_code, :string

  scope :default, -> { friendly.find('convene') }

  def unlocked?
    access_level&.to_sym != :locked
  end

  def locked?
    access_level&.to_sym == :locked
  end

  # @see {Hookups}
  has_many :space_hookups

  def jitsi_meet_domain
    hookups.find { |h| h.is_a?(Hookups::JitsiHookup) }.meet_domain
  end

  def hookups
    space_hookups.lazy.map do |space_hookup|
      Hookups.from_space_hookup(space_hookup)
    end
  end
end

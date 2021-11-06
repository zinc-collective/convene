# A Room in Convene acts as a gathering place.
class Room < ApplicationRecord
  # The space whose settings govern the default publicity and access controls for the Room.
  belongs_to :space

  # Human-friendly description of the room.
  attribute :name, :string
  validates :name, presence: true

  # URI-friendly description of the room.
  attribute :slug, :string
  validates :slug, uniqueness: { scope: :space_id }

  # FriendlyId does the legwork to make the slug uri-friendly
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :space

  # A Room's Access Level indicates what a participant must know in order to gain access to the room.
  # `unlocked` indicates that the participant does not need to know anything to gain access.
  # `locked` indicates that only participants who know the rrooms `access_code` may access the room.
  # `internal` indicates that only participants who are Space Members _or_ know the Spaces `access_code` may
  # access the room.
  attribute :access_level, :string, default: 'unlocked'

  # A room's Access Code is a "secret" that, when known, grants access to the room.
  attribute :access_code, :string
  validates :access_code, presence: { if: :locked? }

  def locked?
    access_level&.to_sym == :locked
  end

  def unlocked?
    access_level&.to_sym == :unlocked
  end

  def internal?
    access_level&.to_sym == :internal
  end

  # A Room's Publicity Level indicates how visible the room is.
  # `listed` - The room is discoverable by anyone in the space lobby.
  # `unlisted` - The room is only visible to it's owners and people who have been in it before.
  PUBLICITY_LEVELS = [ :listed, :unlisted].freeze
  attribute :publicity_level, :string
  validates :publicity_level, presence: true, inclusion: { in: PUBLICITY_LEVELS + PUBLICITY_LEVELS.map(&:to_s) }

  scope :listed,   -> { where(publicity_level: :listed) }
  scope :unlisted, -> { where(publicity_level: :unlisted) }

  def listed?
    publicity_level&.to_sym == :listed
  end

  def unlisted?
    publicity_level&.to_sym == :unlisted
  end

  # Links People to the room for permissioning
  has_many :room_ownerships, inverse_of: :room

  # The People who own the room
  has_many :owners, through: :room_ownerships

  has_many :furniture_placements
  accepts_nested_attributes_for :furniture_placements

  def full_slug
    "#{space.slug}--#{slug}"
  end

  def video_host
    space.jitsi_meet_domain
  end

  def enterable?(access_code)
    return true if access_level == 'unlocked'

    can_enter = self.access_code == access_code
    errors.add(:base, 'Invalid access code') if access_code
    can_enter
  end
end

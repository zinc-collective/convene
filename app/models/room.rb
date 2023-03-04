# A Room in Convene acts as a gathering place.
class Room < ApplicationRecord
  # The space whose settings govern the default publicity and access controls for the Room.
  belongs_to :space
  include WithinLocation
  self.location_parent = :space

  # Human-friendly description of the room.
  attribute :name, :string
  validates :name, presence: true

  # URI-friendly description of the room.
  attribute :slug, :string
  validates :slug, uniqueness: {scope: :space_id}

  # FriendlyId does the legwork to make the slug uri-friendly
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :space

  ACCESS_LEVELS = %i[internal public].freeze
  # A Room's Access Level indicates what a participant must know in order to gain access to the room.
  # `internal` only Members may access the Room
  attribute :access_level, :string, default: :public

  def internal?
    access_level&.to_sym == :internal
  end

  def public?
    access_level&.to_sym == :public
  end

  # A Room's Publicity Level indicates how visible the room is.
  # `listed` - The room is discoverable by anyone in the space lobby.
  # `unlisted` - The room is not listed.

  PUBLICITY_LEVELS = %i[listed unlisted].freeze
  attribute :publicity_level, :string
  validates :publicity_level, presence: true, inclusion: {in: PUBLICITY_LEVELS + PUBLICITY_LEVELS.map(&:to_s)}

  scope :listed, -> { where(publicity_level: :listed) }
  scope :unlisted, -> { where(publicity_level: :unlisted) }

  def listed?
    publicity_level&.to_sym == :listed
  end

  def unlisted?
    publicity_level&.to_sym == :unlisted
  end

  has_many :furniture_placements, dependent: :destroy_async
  accepts_nested_attributes_for :furniture_placements

  def full_slug
    "#{space.slug}--#{slug}"
  end

  def entrance?
    space.entrance == self
  end

  def ==(other)
    super(other.becomes(Room))
  end
end

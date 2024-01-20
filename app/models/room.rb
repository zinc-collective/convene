# A Room in Convene acts as a gathering place.
class Room < ApplicationRecord
  belongs_to :hero_image, class_name: "Media", optional: true
  belongs_to :feed_image, class_name: "Media", optional: true

  accepts_nested_attributes_for :hero_image

  # The space whose settings govern the default publicity and access controls for the Room.
  belongs_to :space, inverse_of: :rooms
  location(parent: :space)

  # Human-friendly description of the room.
  attribute :name, :string
  validates :name, presence: true

  # URI-friendly description of the room.
  attribute :slug, :string
  validates :slug, uniqueness: {scope: :space_id}

  # FriendlyId does the legwork to make the slug uri-friendly
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :space

  # A Room's Access Level indicates what a participant must know in order to gain access to the room.
  # `internal` only Members may access the Room
  enum access_level: {
    public: "public",
    internal: "internal"
  }, _suffix: :access
  alias_method :internal?, :internal_access?
  alias_method :public?, :public_access?

  has_many :gizmos, dependent: :destroy, inverse_of: :room, class_name: :Furniture
  accepts_nested_attributes_for :gizmos

  DESCRIPTION_MAX_LENGTH = 300
  validates :description, length: {maximum: DESCRIPTION_MAX_LENGTH, allow_blank: true}

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

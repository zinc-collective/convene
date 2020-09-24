# A Room in Convene acts as a gathering place.
class Room < ApplicationRecord
  # The workspace whose settings govern the default publicity and access controls for the Room.
  belongs_to :workspace

  # Human-friendly description of the room.
  attribute :name, :string

  # URI-friendly description of the room.
  attribute :slug, :string
  validates :slug, uniqueness: { scope: :workspace_id }

  # FriendlyId's does the legwork to make the slug uri-friendly
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :workspace

  # A Room's Access Level indicates what a participant must know in order to gain access to the room.
  # `unlocked` indicates that the participant does not need to know anything to gain access.
  # `locked` indicates that only participants who know the rrooms `access_code` may access the room.
  # `internal` indicates that only participants who are Workspace Members _or_ know the Workspaces `access_code` may
  # access the room.
  attribute :access_level, :string

  # A room's Access Code is a "secret" that, when known, grants access to the room.
  attribute :access_code, :string

  # A Room's Publicity Level indicates how visible the room is.
  # `listed` - The room is discoverable by anyone in the workspace lobby.
  # `unlisted` - The room is only visible to it's owners and people who have been in it before.
  attribute :publicity_level
  validates :publicity_level, presence: true, inclusion: { in: ['listed', 'unlisted', :listed, :unlisted] }

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

  scope :listed,   -> { where(publicity_level: :listed) }
  scope :unlisted, -> { where(publicity_level: :unlisted) }

  scope :owned_by,      -> (person) { joins(:owners).where(room_ownerships: { owner: person }) }
  scope :accessable_by, -> (person = nil) { union(self.owned_by(person)).union(self.listed) }

  def enterable?(access_code)
    return true if access_level == 'unlocked'
    can_enter = self.access_code == access_code
    errors[:base] << "Invalid access code" if access_code
    can_enter
  end
end

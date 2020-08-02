# A Workspace is a collection of infrastructure resources
# for collaboration
class Workspace < ApplicationRecord
  # Which client owns the workspace
  belongs_to :client

  # The fully-qualified domain to enter the workspace
  attribute :branded_domain, :string

  # The domain we expect jitsi meet to be running on
  attribute :jitsi_meet_domain, :string

  # The human-friendly name for the workspace
  attribute :name, :string

  # The URI-friendly name for the workspace
  attribute :slug, :string
  validates :slug, uniqueness: true

  # FriendlyId's does the legwork to make the slug uri-friendly
  extend FriendlyId

  friendly_id :name, use: :slugged

  # Joins People to workspaces for permissioning and
  # other purposes
  has_many :workspace_memberships, inverse_of: :workspace

  # The People with permissions for the Workspace
  has_many :members, through: :workspace_memberships

  # The Rooms within this Workspace
  has_many :rooms, inverse_of: :workspace

  # A Workspace's Access Level indicates what a participant must know in order to gain access.
  # `unlocked` The participant does not need to know anything to gain access.
  # `locked` Participants must know the Workspace's `access_code` to gain access.
  attribute :access_level, :string

  # A room's Access Code is a "secret" that, when known, grants access to the room.
  attribute :access_code, :string

  def unlocked?
    access_level&.to_sym != :locked
  end

  def locked?
    access_level&.to_sym == :locked
  end
end

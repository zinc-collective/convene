# A Workspace is a collection of infrastructure resources
# for collaboration
class Workspace < ApplicationRecord
  # Which client owns the workspace
  belongs_to :client

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
end

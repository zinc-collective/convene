# frozen_string_literal: true

# A Space is a collection of infrastructure resources
# for collaboration
class Space < ApplicationRecord
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
  has_many :memberships, inverse_of: :space, dependent: :destroy

  # The People with permissions for the Space
  has_many :members, through: :memberships

  # Inviting new members
  has_many :invitations, inverse_of: :space, dependent: :destroy

  # The Rooms within this Space
  has_many :rooms, inverse_of: :space, dependent: :destroy
  has_many :gizmos, through: :rooms, inverse_of: :space

  has_many :agreements, inverse_of: :space, dependent: :destroy

  belongs_to :entrance, class_name: "Room", optional: true

  # @see {Utility}
  # @returns {ActiveRecord::Relation<Utilities>}
  has_many :utilities, inverse_of: :space, dependent: :destroy

  attribute :brand_header, :boolean
  attribute :brand_color, :string

  def parent_location
    []
  end

  def configured?(current_space)
    current_space.rooms.blank? || current_space.entrance_id.blank? || current_space.members.blank? || current_space.entrance&.gizmos.blank?
  end

  attr_accessor :blueprint
end

# frozen_string_literal: true

# A Space is a collection of infrastructure resources
# for collaboration
class Space < ApplicationRecord
  include WithinLocation

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
  has_many :memberships, inverse_of: :space, dependent: :destroy_async

  # The People with permissions for the Space
  has_many :members, through: :memberships

  # Inviting new members
  has_many :invitations, inverse_of: :space, dependent: :destroy_async

  # The Rooms within this Space
  has_many :rooms, inverse_of: :space, dependent: :destroy_async

  belongs_to :entrance, class_name: "Room", optional: true

  # @see {Utilities}
  # @see {UtilityHookup}
  # @returns {ActiveRecord::Relation<UtilityHookups>}
  has_many :utility_hookups, dependent: :destroy_async

  def parent_location
    []
  end

  attr_accessor :blueprint
end

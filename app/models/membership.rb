# frozen_string_literal: true

class Membership < ApplicationRecord
  # Which space the person is in
  belongs_to :space

  # Which person is in the space
  belongs_to :member, class_name: :Person

  has_many :sent_invitations, ->(membership) { where(space: membership.space) },
    through: :member, source: :invitations, inverse_of: :invitor

  # Which invitation was accepted for this membership to be created
  belongs_to :invitation, optional: true

  validates :member, uniqueness: {scope: :space_id}

  def member_name
    member.display_name
  end

  enum :status, {
    active: "active",
    revoked: "revoked"
  }
end

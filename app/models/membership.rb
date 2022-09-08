# frozen_string_literal: true

class Membership < ApplicationRecord
  # Which space the person is in
  belongs_to :space

  # Which person is in the space
  belongs_to :member, class_name: :Person

  # Which invitation was accepted for this membership to be created
  belongs_to :invitation, optional: true

  validates :member, uniqueness: { scope: :space_id }

  enum status: {
    active: 'active',
    revoked: 'revoked'
  }
end

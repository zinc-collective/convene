# frozen_string_literal: true

class SpaceMembership < ApplicationRecord
  # Which space the person is in
  belongs_to :space

  # Which person is in the space
  belongs_to :member, class_name: :Person

  validates :member, uniqueness: { scope: :space_id }
end

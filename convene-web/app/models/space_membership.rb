class SpaceMembership < ApplicationRecord
  # Which space the person is in
  belongs_to :space

  # Which person is in the space
  belongs_to :member, class_name: :Person
end

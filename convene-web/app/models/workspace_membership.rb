class WorkspaceMembership < ApplicationRecord
  # Which workspace the person is in
  belongs_to :workspace

  # Which person is in the workspace
  belongs_to :member, class_name: :Person
end
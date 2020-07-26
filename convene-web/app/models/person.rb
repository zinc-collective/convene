# A representation of a human
class Person < ApplicationRecord
  # Joins the person to the workspaces they are part of
  has_many :workspace_memberships, inverse_of: :member, foreign_key: :member_id

  # The Workspaces the Person is part of
  has_many :workspaces, through: :workspace_memberships
end
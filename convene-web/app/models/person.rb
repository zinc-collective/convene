# A representation of a human
class Person < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  passwordless_with :email

  # Joins the person to the workspaces they are part of
  has_many :workspace_memberships, inverse_of: :member, foreign_key: :member_id

  # The Workspaces the Person is part of
  has_many :workspaces, through: :workspace_memberships

  def name
    super || "You"
  end

  def avatar_url
    "http://placekitten.com/40/40"
  end

  def self.fetch_resource_for_passwordless(email)
    find_or_create_by(email: email)
  end
end
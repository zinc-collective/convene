# A representation of a human
class Person < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  passwordless_with :email

  # Joins the person to the spaces they are part of
  has_many :space_memberships, inverse_of: :member, foreign_key: :member_id

  # The Spaces the Person is part of
  has_many :spaces, through: :space_memberships

  has_many :identities

  def self.fetch_resource_for_passwordless(email)
    find_or_create_by(email: email)
  end

  # @param [Space]
  # @return [Identity]
  def identity_in(space)
    identities.find_by!(space: space)
  end

  def avatar_url
    # TODO: Allow person to upload their image
    "/avatar.svg"
  end
end

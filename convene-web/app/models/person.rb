# A representation of a human
class Person < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Joins the person to the spaces they are part of
  has_many :space_memberships, inverse_of: :member, foreign_key: :member_id

  # The Spaces the Person is part of
  has_many :spaces, through: :space_memberships

  def member_of?(space)
    spaces.include?(space)
  end

  def authenticated?
    true
  end
end

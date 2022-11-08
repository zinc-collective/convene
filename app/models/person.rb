# frozen_string_literal: true

# A representation of a human
class Person < ApplicationRecord
  validates :email, presence: true, uniqueness: {case_sensitive: false}

  # Ways for the person to sign in
  has_many :authentication_methods, inverse_of: :person, dependent: :destroy_async

  # Joins the person to the spaces they are part of
  has_many :memberships, inverse_of: :member, foreign_key: :member_id, dependent: :destroy_async
  has_many :active_memberships, -> { active }, class_name: :Membership, inverse_of: :member, foreign_key: :member_id

  # The Spaces the Person is part of
  has_many :spaces, through: :active_memberships
  has_many :rooms, through: :spaces

  has_many :invitations, inverse_of: :invitor, foreign_key: :invitor_id

  def member_of?(space)
    spaces.include?(space)
  end

  def operator?
    false
  end

  def display_name
    return name if name.present?

    email
  end

  def authenticated?
    true
  end
end

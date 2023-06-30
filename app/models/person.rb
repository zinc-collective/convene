# frozen_string_literal: true

# A representation of a human
class Person < ApplicationRecord
  strip_attributes only: [:email]

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  # Ways for the person to sign in
  has_many :authentication_methods, inverse_of: :person, dependent: :destroy

  # Joins the person to the spaces they are part of
  has_many :memberships, inverse_of: :member, foreign_key: :member_id, dependent: :destroy
  has_many :active_memberships, -> { active }, class_name: :Membership, inverse_of: :member, foreign_key: :member_id, dependent: :destroy

  # The Spaces the Person is part of
  has_many :spaces, through: :active_memberships
  has_many :rooms, through: :spaces

  has_many :invitations, inverse_of: :invitor, foreign_key: :invitor_id, dependent: :destroy

  before_save :downcase_email, if: :email_changed?

  def member_of?(space)
    spaces.include?(space)
  end

  def display_name
    return name if name.present?

    email
  end

  def authenticated?
    true
  end

  private

  def downcase_email
    self.email = email&.downcase
  end
end

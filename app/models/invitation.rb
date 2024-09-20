# frozen_string_literal: true

class Invitation < ApplicationRecord
  location(parent: :space)

  strip_attributes only: [:email]

  belongs_to :space, inverse_of: :invitations

  belongs_to :invitor, class_name: :Person, inverse_of: :invitations

  has_one :membership

  default_scope -> { order(updated_at: :desc) }

  attribute :name, :string
  validates :name, presence: true

  attribute :email, :string
  validates :email, presence: true

  enum :status, {
    pending: "pending",
    accepted: "accepted",
    rejected: "rejected",
    expired: "expired",
    ignored: "ignored",
    revoked: "revoked"
  }

  validates :status, inclusion: {in: statuses.keys}

  # @!method invitor_display_name
  #   @see Person#display_name
  delegate :display_name, to: :invitor, prefix: true, allow_nil: true

  attribute :last_sent_at, :datetime
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  validate :not_ignored_space
  validate :not_expired, if: lambda {
    will_save_change_to_attribute?(:status, to: "accepted")
  }

  EXPIRATION_PERIOD = 14.days

  def expired?
    created_at.present? && created_at < EXPIRATION_PERIOD.ago
  end

  def email=(email)
    super(email&.downcase)
  end

  private

  def not_ignored_space
    return if will_save_change_to_attribute?(:status, from: "ignored")
    return unless Invitation.ignored.exists?(space: space, email: email)

    errors.add(:email, :invitee_ignored_space)
  end

  def not_expired
    return unless expired?

    errors.add(:base, :invitation_expired)
  end
end

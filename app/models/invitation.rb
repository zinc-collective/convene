# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :space, inverse_of: :invitations

  belongs_to :invitor, class_name: :Person, inverse_of: :invitations

  default_scope -> { order(updated_at: :desc) }

  attribute :name, :string
  validates :name, presence: true

  attribute :email, :string
  validates :email, presence: true

  # Kelly H, Zee, Egbet decided these are the possible invitation statuses:
  # pending - email was not sent yet due to mailer issues etc.
  # sent - email was sent but not accepted
  # accepted - receiver accepted the invitation
  # rejected - receivers rejected the invitation
  # expired - Invitation was sent too long ago
  # ignored - receiver ignored the invitation
  enum status: {
    pending: "pending",
    sent: "sent",
    accepted: "accepted",
    rejected: "rejected",
    expired: "expired",
    ignored: "ignored"
  }

  validates :status, inclusion: { in: statuses.keys }

  # @!method invitor_display_name
  #   @see Person#display_name
  delegate :display_name, to: :invitor, prefix: true, allow_nil: true

  attribute :last_sent_at, :datetime
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  validate :not_ignored_space
  validate :not_expired, if: ->() do
    will_save_change_to_attribute?(:status, to: "accepted")
  end

  EXPIRATION_PERIOD = 14.days

private
  def expired?
    created_at < EXPIRATION_PERIOD.ago
  end

  def not_ignored_space
   return if will_save_change_to_attribute?(:status, from: "ignored")
   return unless Invitation.ignored.where(space: space, email: email).exists?

   errors.add(:email, :invitee_ignored_space)
  end

  def not_expired
    return unless expired?

    errors.add(:base, :invitation_expired)
  end
end

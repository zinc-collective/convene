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
  STATUSES = %w[pending sent accepted rejected expired].freeze

  attribute :status, :string
  validates :status, inclusion: STATUSES

  def accepted?
    status.to_sym == :accepted
  end

  def invitor_display_name
    invitor.display_name
  end

  attribute :last_sent_at, :datetime
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
end

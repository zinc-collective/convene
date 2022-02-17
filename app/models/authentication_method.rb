# {People} can have multiple methods to authenticate, such as email addresses,
# phone numbers, one-time passwords, etc.
class AuthenticationMethod < ApplicationRecord
  belongs_to :person, optional: true

  attribute :contact_method, :string
  validates :contact_method, presence: true
  attribute :contact_location, :string
  validates :contact_location, presence: true

  attribute :confirmed_at, :datetime

  lockbox_encrypts :one_time_password_secret
  attribute :last_one_time_password_at, :datetime

  before_validation :set_one_time_password_secret, only: :create
  before_validation :set_person, only: :create

  def set_one_time_password_secret
    self.one_time_password_secret ||= ROTP::Base32.random
  end

  def set_person
    self.person ||= Person.find_or_create_by(email: contact_location)
  end

  def verify?(one_time_password)
    totp.verify(one_time_password).present?
  end

  def one_time_password
    totp.at(last_one_time_password_at)
  end

  def totp
    @totp ||= ROTP::TOTP.new(one_time_password_secret, interval: 2.hours.to_i)
  end

  def bump_one_time_password!
    update!(last_one_time_password_at: Time.now)
  end

  def send_one_time_password!(space)
    bump_one_time_password!
    AuthenticatedSessionMailer.one_time_password_email(self, space).deliver_later
  end

  def confirm!
    return if confirmed?

    update(confirmed_at: Time.now)
  end

  def confirmed?
    confirmed_at.present?
  end
end

class Profile < ApplicationRecord
  validates :person,
    uniqueness: { scope: :space },
    presence: true
end

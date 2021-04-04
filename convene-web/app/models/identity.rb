class Identity < ApplicationRecord
  validates :person,
    uniqueness: { scope: :space },
    presence: true
end

class Journal::Entry < ApplicationRecord
  self.table_name = "journal_entries"

  scope :recent, -> { order(published_at: :asc) }

  attribute :headline, :string
  attribute :body, :string
  validates :body, presence: true

  attribute :published_at, :datetime

  belongs_to :room, inverse_of: :journal_entries, class_name: "Journal::Room"
  delegate :space, to: :room

  def published?
    published_at.present?
  end
end
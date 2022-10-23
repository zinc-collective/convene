class Journal::Entry < ApplicationRecord
  self.table_name = 'journal_entries'
  include RendersMarkdown

  scope :recent, -> { order('published_at DESC NULLS FIRST') }

  attribute :headline, :string
  attribute :body, :string
  validates :body, presence: true

  # URI-friendly description of the entry.
  attribute :slug, :string
  validates :slug, uniqueness: { scope: :room_id }

  # FriendlyId does the legwork to make the slug uri-friendly
  extend FriendlyId
  friendly_id :headline, use: :scoped, scope: :room

  attribute :published_at, :datetime

  belongs_to :room, inverse_of: :journal_entries, class_name: 'Journal::Room'
  delegate :space, to: :room

  def published?
    published_at.present?
  end

  def to_html
    render_markdown(body)
  end

  def to_param
    slug
  end
end

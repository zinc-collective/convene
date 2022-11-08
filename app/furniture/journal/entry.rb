class Journal::Entry < ApplicationRecord
  self.table_name = "journal_entries"
  include RendersMarkdown
  extend StripsNamespaceFromModelName

  scope :recent, -> { order("published_at DESC NULLS FIRST") }

  attribute :headline, :string
  attribute :body, :string
  validates :body, presence: true

  # URI-friendly description of the entry.
  attribute :slug, :string
  validates :slug, uniqueness: {scope: :journal_id}

  # FriendlyId does the legwork to make the slug uri-friendly
  extend FriendlyId
  friendly_id :headline, use: :scoped, scope: :journal

  attribute :published_at, :datetime

  # @!attribute journal
  #   @return [Journal::Journal]
  belongs_to :journal, class_name: "Journal::Journal", inverse_of: :entries
  delegate :room, :space, to: :journal

  def published?
    published_at.present?
  end

  def to_html
    render_markdown(body)
  end

  def to_param
    slug
  end

  def location(action = :show)
    case action
    when :new
      [:new] + journal.location + [:entry]
    when :edit
      [:edit] + journal.location + [self]
    else
      journal.location + [self]
    end
  end
end

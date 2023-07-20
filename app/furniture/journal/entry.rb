class Journal
  class Entry < ApplicationRecord
    location(parent: :journal)

    self.table_name = "journal_entries"
    extend StripsNamespaceFromModelName

    scope :recent, -> { order("published_at DESC NULLS FIRST") }

    attribute :headline, :string
    validates :headline, presence: true
    attribute :body, :string
    validates :body, presence: true

    # URI-friendly description of the entry.
    attribute :slug, :string
    validates :slug, uniqueness: {scope: :journal_id}

    strip_attributes only: [:body, :headline, :slug]

    # FriendlyId does the legwork to make the slug uri-friendly
    extend FriendlyId
    friendly_id :headline, use: :scoped, scope: :journal

    attribute :published_at, :datetime

    # @!attribute journal
    #   @return [Journal::Journal]
    belongs_to :journal, inverse_of: :entries
    has_one :room, through: :journal
    has_one :space, through: :journal
    before_save :extract_keywords, if: :will_save_change_to_body?

    scope :matching_keywords, ->(keywords) { where("keywords::text[] && ARRAY[?]::text[]", keywords) }

    def published?
      published_at.present?
    end

    def extract_keywords
      self.keywords = journal.keywords.extract_and_create_from!(body).pluck(:canonical_keyword)
    end

    def keywords=(keywords)
      super(keywords.uniq)
    end

    def keywords
      journal.keywords.search(*super)
    end

    def to_param
      slug
    end
  end
end

class Journal
  class Entry < ApplicationRecord
    location(parent: :journal)

    self.table_name = "journal_entries"
    include RendersMarkdown
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
    has_many :terms, through: :journal
    after_save :extract_terms, if: :saved_change_to_body?

    def published?
      published_at.present?
    end

    def to_html
      render_markdown(body)
    end

    def self.renderer
      @_renderer ||= Redcarpet::Markdown.new(
        Renderer.new(filter_html: true, with_toc_data: true),
        autolink: true, strikethrough: true,
        no_intra_emphasis: true,
        lax_spacing: true,
        fenced_code_blocks: true, disable_indented_code_blocks: true,
        tables: true, footnotes: true, superscript: true, quote: true
      )
    end

    def extract_terms
      body.scan(/#(\w+)/)&.flatten&.each do |term|
        next if journal.terms.where("aliases ILIKE ?", term)
          .or(journal.terms.where(canonical_term: term)).exists?

        journal.terms.find_or_create_by!(canonical_term: term)
      end
    end

    def to_param
      slug
    end
  end
end

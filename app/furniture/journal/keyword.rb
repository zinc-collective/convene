class Journal
  class Keyword < ApplicationRecord
    location(parent: :journal)
    extend StripsNamespaceFromModelName

    self.table_name = "journal_keywords"
    validates :canonical_keyword, presence: true, uniqueness: {case_sensitive: false, scope: :journal_id}
    belongs_to :journal, inverse_of: :keywords

    scope(:search, lambda do |*keywords|
      where("lower(aliases::text)::text[] && ARRAY[?]::text[]", keywords.map(&:downcase))
          .or(where("lower(canonical_keyword) IN (?)", keywords.map(&:downcase)))
    end)

    def entries
      journal.entries.matching_keywords(canonical_with_aliases)
    end

    def canonical_with_aliases
      [canonical_keyword] + (aliases.presence || [])
    end

    def to_param
      canonical_keyword
    end

    def self.extract_and_create_from!(body)
      body.scan(/#(\w+)/)&.flatten&.map do |keyword|
        existing_keyword = search(keyword).first

        next existing_keyword if existing_keyword.present?

        find_or_create_by!(canonical_keyword: keyword)
      end
    end
  end
end

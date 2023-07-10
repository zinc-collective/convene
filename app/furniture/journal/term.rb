class Journal
  class Term < ApplicationRecord
    location(parent: :journal)

    self.table_name = "journal_terms"
    validates :canonical_term, presence: true
    belongs_to :journal, inverse_of: :terms

    def self.extract_and_create_from!(body)
      body.scan(/#(\w+)/)&.flatten&.each do |term|
        next if where("aliases ILIKE ?", term)
          .or(where(canonical_term: term)).exists?

        find_or_create_by!(canonical_term: term)
      end
    end
  end
end

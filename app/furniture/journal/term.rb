class Journal
  class Term < ApplicationRecord
    location(parent: :journal)

    self.table_name = "journal_terms"
    validates :canonical_term, presence: true
    belongs_to :journal, inverse_of: :terms
  end
end

class Journal
  class Keyword < ApplicationRecord
    location(parent: :journal)

    self.table_name = "journal_keywords"
    validates :canonical_keyword, presence: true, uniqueness: {case_sensitive: false, scope: :journal_id}
    belongs_to :journal, inverse_of: :keywords

    def self.extract_and_create_from!(body)
      body.scan(/#(\w+)/)&.flatten&.each do |keyword|
        next if where(":aliases = ANY (aliases)", aliases: keyword)
          .or(where(canonical_keyword: keyword)).exists?

        find_or_create_by!(canonical_keyword: keyword)
      end
    end
  end
end

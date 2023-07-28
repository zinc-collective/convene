class Journal
  # Merges one {Journal::Keyword} into another and tidies up after.
  class Keyword::Merge
    # @param from {Journal::Keyword}
    # @param into {Journal::Keyword}
    def self.call(from:, into:)
      into.aliases = into.aliases + from.canonical_with_aliases
      Keyword.transaction do
        into.save!
        from.destroy!
        into.entries.find_each do |entry|
          entry.extract_keywords
          entry.save!
        end
      end
    end
  end
end

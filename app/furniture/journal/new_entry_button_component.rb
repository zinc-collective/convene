class Journal
  class NewEntryButtonComponent < ApplicationComponent
    attr_accessor :keyword, :journal
    def initialize(keyword: nil, journal: keyword&.journal)
      self.keyword = keyword
      self.journal = journal
    end

    def render?
      policy(new_entry).new?
    end

    def location
      journal.location(:new, child: :entry, query_params: location_query_params)
    end

    private def location_query_params
      return nil if keyword.blank?

      {entry: {body: "##{keyword.canonical_with_aliases.join(" #")}"}}
    end

    private def new_entry
      @new_entry ||= journal.entries.new
    end
  end
end

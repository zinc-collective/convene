# frozen_string_literal: true

# @see features/furniture/journal.feature.md
class Journal
  include Placeable
  def self.append_routes(router)
    router.resource :journal do
      router.resources :entries, module: 'journal'
    end
  end

  def entries
    room.becomes(Room).journal_entries.recent
  end
end

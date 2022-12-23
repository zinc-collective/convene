# frozen_string_literal: true

# @see features/furniture/journal.feature.md
class Journal
  def self.append_routes(router)
    router.resources :journals do
      router.resources :entries, module: "journal"
    end
  end

  def self.from_placement(placement)
    placement.becomes(Journal)
  end
end

# frozen_string_literal: true

module Furniture
  # Allows a Space to receive eChecks
  # @see features/furniture/check-drop-off.feature
  class CheckDropbox
    include Placeable

    def self.append_routes(router)
      router.scope module: 'check_dropbox' do
        router.resource :check_dropbox, only: [:show] do
          router.resources :checks, only: %i[create index]
        end
      end
    end

    # @returns [ItemRepository<Check>]
    def checks
      ItemRepository.new(type: Check, item_records: placement.item_records, space: placement.space)
    end

    def link_token_for(person)
      utilities.plaid.create_link_token(person: person, space: placement.space)
    end
  end
end

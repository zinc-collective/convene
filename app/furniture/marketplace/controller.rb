class Marketplace
  class Controller < FurnitureController
    include CurrentPerson
    expose :marketplace, scope: -> { policy_scope(Marketplace) }
    delegate :bazaar, to: :marketplace
    helper_method :bazaar

    helper_method def shopper
      @shopper ||= current_person.find_or_create_shopper
    end
  end
end

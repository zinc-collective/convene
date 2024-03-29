class Marketplace
  class Controller < FurnitureController
    expose :marketplace, scope: -> { policy_scope(Marketplace) }
    delegate :bazaar, to: :marketplace
    helper_method :bazaar
    layout "marketplace"

    helper_method def shopper
      @shopper ||= if current_person.is_a?(Guest)
        Shopper.find_or_create_by(id: session[:guest_shopper_id] ||= SecureRandom.uuid)
      else
        Shopper.find_or_create_by(person: current_person)
      end
    end
  end
end

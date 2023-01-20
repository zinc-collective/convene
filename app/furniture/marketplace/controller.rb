class Marketplace
  class Controller < FurnitureController
    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end

    helper_method def shopper
      @shopper ||= if current_person.is_a?(Guest)
        Shopper.find_or_create_by(id: session[:guest_shopper_id] ||= SecureRandom.uuid)
      else
        Shopper.find_or_create_by(person: current_person)
      end
    end
  end
end

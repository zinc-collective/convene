class Marketplace
  class CheckoutsController < FurnitureController
    def new
      authorize(checkout)
    end

    helper_method def checkout
      @checkout ||= cart.build_checkout(shopper: shopper)
    end

    helper_method def shopper
      @shopper ||= if current_person.is_a?(Guest)
        Shopper.find_or_create_by(id: session[:current_cart] ||= SecureRandom.uuid)
      else
        Shopper.find_or_create_by(person: current_person)
      end
    end

    helper_method def cart
      @cart ||= marketplace.carts.find_or_create_by(shopper: shopper)
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end
  end
end

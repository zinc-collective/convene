class Marketplace
  class CheckoutsController < FurnitureController

    def show
      authorize(checkout)
      if params[:stripe_session_id].present?
        checkout.update!(status: :paid, stripe_session_id: params[:stripe_session_id])
        checkout.cart.update!(status: :checked_out)
        flash[:notice] = t('.success')
      end
    end

    def create
      authorize(checkout)

      if checkout.save
        stripe_session = checkout.create_stripe_session(
          success_url: "#{polymorphic_url(checkout.location)}?stripe_session_id={CHECKOUT_SESSION_ID}",
          cancel_url: polymorphic_url(marketplace.location)
        )
        redirect_to stripe_session.url, status: :see_other, allow_other_host: true
      else
        redirect_to(
          [marketplace.room.space, marketplace.room],
          # TODO: make this a nicer, I18ed message
          alert: flash[:alert] = checkout.errors.full_messages.join(" ")
        )
      end
    end

    helper_method def checkout
      @checkout ||= if params[:id]
        Checkout.find(params[:id])
      else
        cart.checkout || cart.build_checkout(shopper: shopper)
      end
    end

    helper_method def shopper
      @shopper ||= if current_person.is_a?(Guest)
        Shopper.find_or_create_by(id: session[:guest_shopper_id] ||= SecureRandom.uuid)
      else
        Shopper.find_or_create_by(person: current_person)
      end
    end

    helper_method def cart
      @cart ||= marketplace.carts.find_or_create_by(shopper: shopper, status: :pre_checkout)
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end
  end
end

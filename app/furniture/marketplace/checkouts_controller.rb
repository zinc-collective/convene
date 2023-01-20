class Marketplace
  class CheckoutsController < Controller
    def show
      authorize(checkout)
      if params[:stripe_session_id].present?
        checkout.complete(stripe_session_id: params[:stripe_session_id])
        flash[:notice] = t('.success')
      end
      redirect_to checkout.becomes(Order).location
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

    helper_method def cart
      @cart ||= marketplace.carts.find_or_create_by(shopper: shopper, status: :pre_checkout)
    end
  end
end

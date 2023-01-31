class Marketplace
  class CheckoutsController < Controller
    def show
      authorize(checkout)
      if params[:stripe_session_id].present?
        checkout.complete(stripe_session_id: params[:stripe_session_id])
        flash[:notice] = t(".success")
      end
      redirect_to order.location
    end

    def create
      authorize(checkout)

      if checkout.valid?
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
      @checkout ||= Checkout.new(cart: cart)
    end

    helper_method def cart
      @cart ||= if params[:cart_id]
        marketplace.carts.find(params[:cart_id])
      else
        marketplace.carts.find_or_create_by(shopper: shopper)
      end
    end

    def order
      @order ||= cart.becomes(Order)
    end
  end
end

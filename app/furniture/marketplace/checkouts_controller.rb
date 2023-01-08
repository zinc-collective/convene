class Marketplace
  class CheckoutsController < FurnitureController
    def new
      authorize(checkout)
      checkout.save!

      line_items = checkout.cart.cart_products.map { |cart_product| {price_data: {currency: "USD", unit_amount: cart_product.product.price_cents, product_data: {name: cart_product.product.name}}, quantity: cart_product.quantity, adjustable_quantity: {enabled: true}} }

      stripe_checkout = Stripe::Checkout::Session.create({
        line_items: line_items,
        mode: "payment",
        success_url: polymorphic_url(checkout.location),
        cancel_url: polymorphic_url(marketplace.location)
      }, {
        api_key: marketplace.stripe_api_key
      })

      redirect_to stripe_checkout.url, status: :see_other, allow_other_host: true
    end

    helper_method def checkout
      @checkout ||= cart.checkout || cart.build_checkout(shopper: shopper)
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

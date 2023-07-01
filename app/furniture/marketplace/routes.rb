class Marketplace
  class Routes
    def self.append_routes(router)
      router.resources :marketplaces, only: [:show, :edit, :update], module: "marketplace" do
        router.resources :stripe_events

        router.resources :notification_methods

        router.resources :carts, only: [] do
          router.resources :cart_products
          router.resource :checkout, only: [:show, :create]
          router.resource :delivery, controller: "cart/deliveries"
        end

        router.resources :tax_rates

        router.resources :delivery_areas

        router.resources :orders, only: [:show, :index]
        router.resources :products
        router.resource :stripe_account
      end
    end
  end
end

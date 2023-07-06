class Marketplace
  class Routes
    def self.append_routes(router)
      router.resources :marketplaces, only: [:show, :edit], module: "marketplace" do
        router.resources :carts, only: [] do
          router.resources :cart_products
          router.resource :checkout, only: [:show, :create]
          router.resource :delivery, controller: "cart/deliveries"
        end

        router.resources :delivery_areas
        router.resources :notification_methods
        router.resources :orders, only: [:show, :index]
        router.resources :products
        router.resource :stripe_account, only: [:show, :new, :create]
        router.resources :stripe_events
        router.resources :tax_rates
      end
    end
  end
end

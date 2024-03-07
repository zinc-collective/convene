class Marketplace
  class Routes
    def self.append_routes(router)
      router.resources :marketplaces, only: [:show, :edit, :update], module: "marketplace" do
        router.resources :carts, only: [] do
          router.resources :cart_products
          router.resource :checkout, only: [:show, :create]
          router.resource :delivery, controller: "cart/deliveries"
          router.resource :delivery_area, controller: "cart/delivery_areas"
        end

        router.resource :flyer
        router.resources :delivery_areas
        router.resources :notification_methods
        router.resources :orders, only: [:show, :index]
        router.resources :products
        router.resource :stripe_account, only: [:show, :new, :create]
        router.resources :stripe_events
        router.resources :tags
        router.resources :tax_rates
        router.resources :vendor_representatives
        router.resources :payment_settings, only: [:index]
      end
    end
  end
end

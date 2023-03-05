class Marketplace
  class Routes
    def self.append_routes(router)
      router.resources :marketplaces, only: [:show, :edit, :update], module: "marketplace" do
        router.resources :stripe_events

        router.resources :carts do
          router.resources :cart_products
          router.resource :checkout, only: [:show, :create]
        end

        router.resources :tax_rates

        router.resources :orders, only: [:show]
        router.resources :products do
          router.resources :tax_rates, only: [:create, :destroy, :index, :show]
        end
        router.resource :stripe_account
      end
    end
  end
end

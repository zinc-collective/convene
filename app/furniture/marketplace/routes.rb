class Marketplace
  class Routes
    def self.append_routes(router)
      router.resources :marketplaces, only: [:show, :edit, :update], module: "marketplace" do
        router.resources :carts do
          router.resources :cart_products
          router.resource :checkout, only: [:show, :create]
        end

        router.resources :orders, only: [:show]
        router.resources :products
        router.resource :stripe_account
      end
    end
  end
end

class Marketplace
  class Routes
    def self.append_routes(router)
      router.resources :marketplaces, only: [:show, :edit, :update], module: "marketplace" do
        router.resources :orders, only: [:show]
        router.resources :products
        router.resources :carts do
          router.resources :cart_products
        end
        router.resources :checkouts, only: [:show, :create]
      end
    end
  end
end

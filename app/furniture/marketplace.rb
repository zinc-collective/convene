class Marketplace
  include Placeable

  def self.append_routes(router)
    router.resource :marketplace, only: [] do
      router.resources :products, only: %i[create index], module: "marketplace"
    end
  end
end

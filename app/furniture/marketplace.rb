# @see features/furniture/marketplace.feature.md
class Marketplace
  include Placeable

  def self.append_routes(router)
    router.resources :marketplace, only: [:show] do
      router.resources :products, :orders, only: %i[new create index], module: 'marketplace'
      router.resources :orders, only: [], module: 'marketplace' do
        router.resources :ordered_products
      end
    end
  end

  def self.from_placement(placement)
    placement.becomes(Marketplace)
  end
end

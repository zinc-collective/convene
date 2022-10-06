# @see features/furniture/marketplace.feature.md
class Marketplace
  include Placeable

  def self.append_routes(router)
    router.resource :marketplace, only: [] do
      router.resources :products, only: %i[new create index], module: 'marketplace'
    end
  end

  def products
    Marketplace::Product.where(space: space)
  end
end

class RemoveMarketplaceProductsDescription < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      remove_column :marketplace_products, :description, :string
    end
  end
end

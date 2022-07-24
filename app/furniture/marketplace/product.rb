class Marketplace::Product
  include ActiveModel::Model
  attr_accessor :name, :price_cents

  def price
    Money.from_cents(price_cents, 'USD')
  end
end

class Marketplace::Item
  include ActiveModel::Model

  def id
    @id ||= SecureRandom.uuid
  end

  def persisted?
    true
  end

  attr_accessor :product, :order

  delegate :price, to: :product

  def save
    order.save
  end

  def quantity
    1
  end
end
# frozen_string_literal: true

class Marketplace
  class OrderedProduct < ApplicationRecord
    self.table_name = 'marketplace_ordered_products'

    belongs_to :order, inverse_of: :ordered_products
    belongs_to :product, inverse_of: :ordered_products
    validates_uniqueness_of :product, scope: :order_id

    attribute :quantity, :integer, default: 0

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end

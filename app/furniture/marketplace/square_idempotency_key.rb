class Marketplace
  class SquareIdempotencyKey
    def self.generate(order_id)
      "#{order_id}_#{SecureRandom.hex(8)}"
    end
  end
end

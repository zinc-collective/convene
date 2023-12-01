class Marketplace
  class SquareIdempotencyKey
    def self.generate(order_id)
      "#{order_id}_#{8.times.map { rand(10) }.join}"
    end
  end
end

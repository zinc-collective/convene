# Utility for managing unique, idempotent identifiers that are associated with
# object data we send and receive from Marketplace vendors' Square accounts.
#
# See: https://developer.squareup.com/docs/build-basics/common-api-patterns/idempotency
class Marketplace
  class SquareIdempotencyKey
    # Combines our system's Order record id with a random value under Square's
    # max length of 192 bytes
    def self.generate(order_id)
      "#{order_id}_#{SecureRandom.hex(8)}"
    end
  end
end

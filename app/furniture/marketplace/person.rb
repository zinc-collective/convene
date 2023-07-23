class Marketplace
  class Person < ::Person
    has_one :shopper, inverse_of: :person

    def find_or_create_shopper
      shopper || create_shopper
    end
  end
end

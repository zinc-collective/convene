class Marketplace
  class Delivery
    class WindowType < ActiveRecord::Type::Value
      def deserialize(value)
        Window.new(value: value)
      end
    end

    def cast(value)
      Window.value(value: value)
    end
  end
end

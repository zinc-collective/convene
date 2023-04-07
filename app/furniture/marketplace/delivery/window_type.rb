class Marketplace
  class Delivery
    class WindowType < ActiveRecord::Type::Value
      def deserialize(value)
        Window.new(value: value)
      end

      def cast(value)
        Window.new(value: value)
      end

      def serialize(window)
        window.value
      end
    end
  end
end

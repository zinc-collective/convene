class Marketplace
  class Delivery
    class WindowType < ActiveRecord::Type::Value
      def cast(value)
        value = begin DateTime.iso8601(value)
        rescue
          value
        end

        Window.new(value: value)
      end

      def serialize(window)
        window.value
      end
    end
  end
end

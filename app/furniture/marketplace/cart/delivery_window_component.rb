class Marketplace
  class Cart
    class DeliveryWindowComponent < ApplicationComponent
      attr_accessor :window

      def initialize(window:, **)
        super(**)
        self.window = window
      end

      def time_like?
        cast_window.respond_to?(:strftime)
      end

      private

      def cast_window
        @cast_window ||= begin
          DateTime.iso8601(window)
        rescue
          window
        end
      end
    end
  end
end

class Marketplace
  class Delivery
    class Window < Model
      attr_writer :value

      def value
        return nil if @value.blank?

        DateTime.iso8601(@value)
      rescue Date::Error => _e
        @value
      end
      delegate(:nil?, :blank?, :empty?, to: :value)

      def strftime(*args, **kwargs)
        value.strftime(*args, **kwargs) if value.respond_to?(:strftime)
        value
      end

      def eql?(other)
        value == other.value
      end
    end
  end
end

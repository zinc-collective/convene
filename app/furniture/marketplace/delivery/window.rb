class Marketplace
  class Delivery
    class Window < Model
      attr_writer :value

      def value
        return nil if @value.blank?
        return @value if time_like?
        DateTime.iso8601(@value)
      rescue Date::Error
        @value
      end
      delegate(:nil?, :blank?, :empty?, to: :value)

      def strftime(*args, **kwargs)
        return value.strftime(*args, **kwargs) if time_like?
        value
      end

      alias_method :to_s, :strftime

      def eql?(other)
        value.eql?(other.value)
      end

      private def time_like?
        @value.respond_to?(:strftime)
      end
    end
  end
end

class Marketplace
  class Delivery
    class Window < Model
      attr_accessor :value
      delegate(:nil?, :blank?, :empty?, to: :value)

      def strftime(*args, **kwargs)
        return value.strftime(*args, **kwargs) if time_like?
        value
      end

      alias_method :to_s, :strftime

      def eql?(other)
        if other.is_a?(Window)
          value.eql?(other.value)
        else
          eql?(WindowType.new.cast(other))
        end
      end

      alias_method :==, :eql?

      def time_like?
        value.respond_to?(:strftime)
      end
    end
  end
end

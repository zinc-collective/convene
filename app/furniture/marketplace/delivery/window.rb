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

      delegate :strftime, to: :value

      def eql?(other)
        value.eql?(other.value)
      end
    end
  end
end

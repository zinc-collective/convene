class Marketplace
  class Cart
    class Delivery
      class EditButtonComponent < ButtonComponent
        attr_accessor :delivery
        def initialize(delivery, label: t("marketplace.cart.deliveries.edit.link_to"),
          shape: "w-full sm:w-auto rounded",
          margin: "mb-1 mt-1 sm:mt-0",
          typography: "no-underline font-normal text-sm text-center",
          color: "bg-primary-100 hover:bg-primary-200 focus:bg-primary-200",
          **kwargs)
          self.delivery = delivery
          super(href: delivery.location(:edit), label: label, title: nil,
                method: :get, turbo_stream: true,
                margin: margin, typography: typography, color: color,
                shape: shape, **kwargs)
        end
      end
    end
  end
end

class Marketplace
  class Cart
    class Delivery
      class EditButtonComponent < ButtonComponent
        attr_accessor :delivery
        def initialize(delivery,
          classes: "shrink font-light text-xs m-0 bg-primary-200 underline",
          label: t('marketplace.cart.deliveries.edit.link_to'))
          self.delivery = delivery
          super(method: :get, href: delivery.location(:edit), label: label, turbo_stream: true, title: nil, classes: classes)
        end
      end
    end
  end
end

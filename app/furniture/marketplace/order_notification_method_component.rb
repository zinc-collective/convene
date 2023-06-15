class Marketplace
  class OrderNotificationMethodComponent < ApplicationComponent
    attr_accessor :order_notification_method
    delegate :contact_location, to: :order_notification_method

    def initialize(order_notification_method:, **kwargs)
      super(**kwargs)

      self.order_notification_method = order_notification_method
    end

    def edit_button
      super(title: t("marketplace.order_notification_methods.edit.link_to", contact_location: contact_location),
            href: order_notification_method.location(:edit))
    end

    def edit_button?
      order_notification_method.persisted? && policy(order_notification_method).edit?
    end

    def destroy_button
      return unless destroy_button?

      ButtonComponent.new(label: "#{t("icons.destroy")} #{t("destroy.link_to")}",
        title: t("marketplace.order_notification_methods.destroy.link_to", contact_location: contact_location),
        href: order_notification_method.location, turbo_stream: true,
        method: :delete,
        confirm: t("destroy.confirm"),
        scheme: :secondary)
    end

    def destroy_button?
      order_notification_method.persisted? && policy(order_notification_method).destroy?
    end
  end
end

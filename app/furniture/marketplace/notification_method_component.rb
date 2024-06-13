class Marketplace
  class NotificationMethodComponent < ApplicationComponent
    attr_accessor :notification_method
    delegate :contact_location, to: :notification_method

    def initialize(notification_method:, **)
      super(**)

      self.notification_method = notification_method
    end

    def edit_button
      super(title: t("marketplace.notification_methods.edit.link_to", contact_location: contact_location),
            href: notification_method.location(:edit))
    end

    def edit_button?
      notification_method.persisted? && policy(notification_method).edit?
    end

    def destroy_button
      return unless destroy_button?

      ButtonComponent.new(label: "#{t("icons.destroy")} #{t("destroy.link_to")}",
        title: t("marketplace.notification_methods.destroy.link_to", contact_location: contact_location),
        href: notification_method.location, turbo_stream: true,
        method: :delete,
        confirm: t("destroy.confirm"),
        scheme: :secondary)
    end

    def destroy_button?
      notification_method.persisted? && policy(notification_method).destroy?
    end
  end
end

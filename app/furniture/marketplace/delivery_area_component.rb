class Marketplace
  class DeliveryAreaComponent < ApplicationComponent
    attr_accessor :delivery_area
    delegate :label, to: :delivery_area

    def initialize(delivery_area:, data: {}, classes: "")
      super(data: data, classes: classes)

      self.delivery_area = delivery_area
    end

    delegate :price, to: :delivery_area

    def edit_button
      super(title: t("marketplace.delivery_areas.edit.link_to", name: delivery_area.label),
            href: delivery_area.location(:edit))
    end

    def edit_button?
      delivery_area.persisted? && policy(delivery_area).edit?
    end

    def destroy_button
      return unless destroy_button?

      Buttons::SecondaryComponent.new(label: "#{t("icons.destroy")} #{t("destroy.link_to")}",
        title: t("marketplace.delivery_areas.destroy.link_to", name: delivery_area.label),
        href: delivery_area.location, turbo_stream: true,
        method: :delete,
        confirm: t("destroy.confirm"))
    end

    def destroy_button?
      delivery_area.persisted? && policy(delivery_area).destroy?
    end
  end
end

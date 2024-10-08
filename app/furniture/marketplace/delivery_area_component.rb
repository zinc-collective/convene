class Marketplace
  class DeliveryAreaComponent < ApplicationComponent
    attr_accessor :delivery_area
    delegate :label, to: :delivery_area

    def initialize(delivery_area:, **)
      super(**)

      self.delivery_area = delivery_area
    end

    def price
      helpers.humanized_money_with_symbol(delivery_area.price)
    end

    def fee_as_percentage
      "#{helpers.number_to_percentage(delivery_area.fee_as_percentage, precision: 0)} of subtotal"
    end

    def fee_description
      if delivery_area.charges_fee_as_percentage? && delivery_area.charges_fee_as_price?
        "#{price} plus #{fee_as_percentage}"
      elsif !delivery_area.charges_fee_as_percentage? && delivery_area.charges_fee_as_price?
        price
      elsif delivery_area.charges_fee_as_percentage? && !delivery_area.charges_fee_as_price?
        fee_as_percentage
      end
    end

    def example_cart
      delivery_area.marketplace.carts.new(delivery_area: delivery_area)
    end

    delegate :order_by, to: :delivery_area

    def edit_button
      super(title: t("marketplace.delivery_areas.edit.link_to", name: delivery_area.label),
            href: delivery_area.location(:edit))
    end

    def edit_button?
      delivery_area.persisted? && policy(delivery_area).edit?
    end

    def archive_button
      return unless archive_button?

      ButtonComponent.new(label: "#{t("icons.archive")} #{t("archive.link_to")}",
        title: t("marketplace.delivery_areas.archive.link_to", name: delivery_area.label),
        href: delivery_area.location, method: :delete, scheme: :secondary)
    end

    def archive_button?
      delivery_area.archivable? && policy(delivery_area).destroy?
    end

    def destroy_button
      return unless destroy_button?

      ButtonComponent.new(label: "#{t("icons.destroy")} #{t("destroy.link_to")}",
        title: t("marketplace.delivery_areas.destroy.link_to", name: delivery_area.label),
        href: delivery_area.location, method: :delete, confirm: t("destroy.confirm"),
        scheme: :secondary)
    end

    def destroy_button?
      delivery_area.destroyable? && policy(delivery_area).destroy?
    end
  end
end

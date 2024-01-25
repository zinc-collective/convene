class Marketplace
  class ProductComponent < ApplicationComponent
    attr_accessor :product
    delegate :name, :description, :location, to: :product

    def initialize(product:, data: {}, classes: "", **kwargs)
      super(data: data, classes: classes, **kwargs)

      self.product = product
    end

    def edit_button
      super(title: t("marketplace.products.edit.link_to", name: name), href: location(:edit))
    end

    # 16:9 of 1290 is 1290:725.625
    # We rounded up.
    # @see https://www.ios-resolution.com/
    FULL_WIDTH_16_BY_9 = [1290, 726]
    def hero_image
      product.photo.variant(resize_to_fill: FULL_WIDTH_16_BY_9)
    end

    def tax_rates
      product.tax_rates.map do |tax_rate|
        "#{tax_rate.label} #{helpers.number_to_percentage(tax_rate.tax_rate, precision: 2)}"
      end.to_sentence
    end

    def price
      helpers.humanized_money_with_symbol(product.price)
    end

    def edit_button?
      product.persisted? && policy(product).edit?
    end

    def archive_button
      return unless archive_button?

      ButtonComponent.new(label: "#{t("icons.archive")} #{t("archive.link_to")}",
        title: t("marketplace.products.archive.link_to", name:),
        href: product.location, method: :delete, scheme: :secondary)
    end

    def archive_button?
      product.archivable? && policy(product).destroy?
    end

    def destroy_button
      return unless destroy_button?

      ButtonComponent.new label: "#{t("icons.destroy")} #{t("destroy.link_to")}",
        title: t("marketplace.products.destroy.link_to", name: product.name),
        href: product.location, method: :delete, confirm: t("destroy.confirm"),
        scheme: :secondary
    end

    def destroy_button?
      product.destroyable? && policy(product).destroy?
    end
  end
end

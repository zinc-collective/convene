class Marketplace
  class TaxRateComponent < ApplicationComponent
    attr_accessor :tax_rate
    delegate :label, to: :tax_rate

    def initialize(tax_rate:, data: {}, classes: "")
      super(data: data, classes: classes)

      self.tax_rate = tax_rate
    end

    def rate
      number_to_percentage(tax_rate.tax_rate, precision: 2)
    end

    def edit_button
      return unless edit_button?

      ButtonComponent.new label: "#{t("icons.edit")} #{t("edit.link_to")}",
        title: t("marketplace.tax_rates.edit.link_to", name: tax_rate.label),
        href: tax_rate.location(:edit), turbo_stream: true,
        method: :get
    end

    def edit_button?
      tax_rate.persisted? && policy(tax_rate).edit?
    end

    def destroy_button
      return unless destroy_button?

      ButtonComponent.new label: "#{t("icons.destroy")} #{t("destroy.link_to")}",
        title: t("marketplace.tax_rates.destroy.link_to", name: tax_rate.label),
        href: tax_rate.location, turbo_stream: true,
        method: :delete
    end

    def destroy_button?
      tax_rate.persisted? && policy(tax_rate).destroy? && tax_rate.products.blank?
    end
  end
end

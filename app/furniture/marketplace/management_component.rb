class Marketplace
  class ManagementComponent < Component
    attr_accessor :marketplace

    def initialize(marketplace:, **kwargs)
      super(**kwargs)

      self.marketplace = marketplace
    end

    def onboarding_component
      OnboardingComponent.new(marketplace: marketplace)
    end

    def button(location, icon:)
      label, href = if location.is_a?(Symbol)
        [t("marketplace.marketplace.#{location}.link_to"),
          marketplace.location(location)]
      elsif location[:child].to_s.pluralize == location[:child].to_s
        [t("marketplace.#{location[:child]}.index.link_to"),
          marketplace.location(**location)]
      else
        [t("marketplace.#{location[:child].to_s.pluralize}.show.link_to"),
          marketplace.location(**location)]
      end

      ButtonComponent.new(label: label, icon: icon, href: href, turbo_stream: false, method: :get, scheme: :secondary)
    end
  end
end

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

    def link_to_child(child, icon:)
      label, href = if child.to_s.pluralize == child.to_s
        [t("marketplace.#{child}.index.link_to"),
          marketplace.location(child:)]
      else
        [t("marketplace.#{child.to_s.pluralize}.show.link_to"),
          marketplace.location(child:)]
      end

      link_to(href, class: "button --secondary w-full text-left") do
        render(SvgComponent.new(icon:, classes: "w-6 h-6 mr-2 inline-block")) +
          label
      end
    end
  end
end

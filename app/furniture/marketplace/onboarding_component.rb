class Marketplace
  class OnboardingComponent < ApplicationComponent
    attr_accessor :marketplace
    delegate :location, :ready_for_shopping?, to: :marketplace

    def initialize(marketplace:, **)
      super(**)
      self.marketplace = marketplace
    end

    def render?
      policy(marketplace).edit? && (!ready_for_shopping? || marketplace.notification_methods.empty?)
    end

    def onboard(resource)
      resource = resource.to_s.pluralize
      tag_builder.p(t(".missing.#{resource}", link: link_to(t("marketplace.#{resource}.new.link_to"), location(:new, child: resource.singularize.to_sym))).html_safe)
    end

    def dom_id
      super(marketplace, :onboarding)
    end
  end
end

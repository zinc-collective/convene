class Marketplace
  class OnboardingComponent < ApplicationComponent
    attr_accessor :marketplace
    delegate :location, :ready_for_shopping?, to: :marketplace

    def initialize(marketplace:, **kwargs)
      super(**kwargs)
      self.marketplace = marketplace
    end

    def render?
      policy(marketplace).edit? && (!ready_for_shopping? || marketplace.notification_methods.empty?)
    end

    def onboard(resource)
      resource = resource.to_s.pluralize
      return if marketplace.read_attribute(resource).present?
      tag_builder.p(t(".missing.#{resource}", link: link_to(t("marketplace.#{resource}.new.link_to"), location(:new, child: resource.singularize.to_sym))).html_safe)
    end
  end
end

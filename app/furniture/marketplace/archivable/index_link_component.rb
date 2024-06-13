class Marketplace
  class Archivable::IndexLinkComponent < Component
    attr_accessor :marketplace, :resource, :to_archive

    def initialize(marketplace:, resource:, to_archive:, **)
      self.marketplace = marketplace
      self.resource = resource
      self.to_archive = to_archive
      super(**)
    end

    def location
      if to_archive
        marketplace.location(child: resource, query_params: {archive: true})
      else
        marketplace.location(child: resource)
      end
    end

    def text
      t(".#{resource}.#{to_archive ? :archive : :active}")
    end
  end
end

class BrandedDomain
  attr_accessor :space_repository

  def initialize(space_repository)
    self.space_repository = space_repository
  end

  # Retrieves a Space
  def space_for_request(request)
    branded_spaces[request.host]
  end

  # @return [TrueClass,FalseClass] True when a Space has a branded_domain that matches the request domain
  def matches?(request)
    space_for_request(request).present?
  end

  # We cache the branded spaces to reduce the database-hits-per-request where we can.
  private def branded_spaces
    Rails.cache.fetch('BrandedSubdomain#branded_spaces', expires_in: 1.minute) do
      space_repository.where.not(branded_domain: nil).each_with_object({}) do |space, branded_domains|
        branded_domains[space.branded_domain] = space
      end
    end
  end
end

class BrandedDomain
  attr_accessor :workspace_repository
  def initialize(workspace_repository)
    self.workspace_repository = workspace_repository
  end

  # Retrieves a Workspace
  def workspace_for_request(request)
    branded_workspaces[request.domain(1_000)]
  end

  # @return [TrueClass,FalseClass] True when a Workspace has a branded_domain that matches the request domain
  def matches?(request)
    workspace_for_request(request).present?
  end

  # We cache the branded workspaces to reduce the database-hits-per-request where we can.
  private def branded_workspaces
    Rails.cache.fetch("BrandedSubdomain#branded_workspaces", expires_in: 1.minute) do
      workspace_repository.where.not(branded_domain: nil).each_with_object({}) do |workspace, branded_domains|
        branded_domains[workspace.branded_domain]=workspace
      end
    end
  end
end
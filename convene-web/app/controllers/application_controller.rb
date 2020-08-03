class ApplicationController < ActionController::Base
  # TODO: When we begin to implement authentication, we'll want this to return an actual Person
  # @returns [nil, Person] The Person for whom we are building a response
  helper_method def current_person
    nil
  end

  # Retrieves the workspace based upon the requests domain or params
  # @returns [nil, Workspace]
  helper_method def current_workspace
    workspace_repository = Workspace.includes(:rooms)
    @current_workspace ||=
      BrandedDomain.new(workspace_repository).workspace_for_request(request) ||
      workspace_repository.friendly.find(params[:id])
  end
end

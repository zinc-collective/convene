class ApplicationController < ActionController::Base
  # Referenced in application layout to display page title
  # Override on a per-controller basis to display different title
  # @returns [String]
  helper_method def page_title
    "ConveneWeb"
  end

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
      if params[:workspace_id]
        workspace_repository.friendly.find(params[:workspace_id])
      else
        BrandedDomain.new(workspace_repository).workspace_for_request(request) ||
        workspace_repository.friendly.find(params[:id])
      end
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # Retrieves the room based upon the current_workspace and params
  # @returns [nil, Room]
  helper_method def current_room
    @current_room ||=
      current_workspace.rooms.friendly.find(
        params[:id] || params[:room_id]
      )
  rescue ActiveRecord::RecordNotFound
    nil
  end

  helper_method def current_access_code(room)
    session.dig(room.id, 'access_code')
  end
end

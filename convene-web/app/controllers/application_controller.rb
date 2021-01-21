class ApplicationController < ActionController::Base
  # Referenced in application layout to display page title
  # Override on a per-controller basis to display different title
  # @returns [String]
  helper_method def page_title
    if current_space.present?
      "Convene - #{current_space.name}"
    else
      'Convene - Video Meeting Spaces'
    end
  end

  include Passwordless::ControllerHelpers

  helper_method :current_person

  private

  # @returns [Guest, Person] the authenticated user, or a Guest
  def current_person
    @current_person ||= authenticate_by_session(Person) || Guest.new
  end

  def require_person!
    return if current_person

    save_passwordless_redirect_location!(Person)
    redirect_to people.sign_in_path, flash: { error: 'Login required' }
  end

  # Retrieves the space based upon the requests domain or params
  # @returns [nil, Space]
  helper_method def current_space
    space_repository = Space.includes(:rooms)
    @current_space ||=
      if params[:space_id]
        space_repository.friendly.find(params[:space_id])
      else
        BrandedDomain.new(space_repository).space_for_request(request) ||
        space_repository.friendly.find(params[:id])
      end
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # Retrieves the room based upon the current_space and params
  # @returns [nil, Room]
  helper_method def current_room
    @current_room ||=
      current_space.rooms.friendly.find(
        params[:id] || params[:room_id]
      )
  rescue ActiveRecord::RecordNotFound
    nil
  end

  helper_method def current_access_code(room)
    session.dig(room.id, 'access_code')
  end
end

# frozen_string_literal: true

# Default controller for new resources; ensures requests fulfill authentication
# and authorization requirements, as well as exposes common helper methods.
#
# @see Admin::BaseController for exposing Operator-specific actions and views
class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :render_not_found

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

  # Helper for Pundit-assisted policy/permissions checks.
  def pundit_user
    current_person
  end

  def require_person!
    return if current_person

    save_passwordless_redirect_location!(Person)
    redirect_to people.sign_in_path, flash: { error: 'Sign in required' }
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

  def render_not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
end

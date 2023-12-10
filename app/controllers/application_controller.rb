# frozen_string_literal: true

# Default controller for new resources; ensures requests fulfill authentication
# and authorization requirements, as well as exposes common helper methods.
class ApplicationController < ActionController::Base
  before_action :enforce_ssl
  before_action :ensure_on_byo_domain

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  include Pundit::Authorization
  after_action :verify_authorized, except: [:index] # rubocop:disable Rails/LexicallyScopedActionFilter
  after_action :verify_policy_scoped
  include Neighborhood::TimeZoneMixin

  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized
  prepend_view_path "app/utilities"
  prepend_view_path "app/furniture"

  protect_from_forgery with: :exception, unless: -> { api_request? }

  # @see https://til.hashrocket.com/posts/3exmhtwqy6-setting-the-urloptions-hash-in-the-controller
  include ActiveStorage::SetCurrent

  # Referenced in application layout to display page title
  # Override on a per-controller basis to display different title
  # @return [String]
  helper_method def page_title
    if current_space.present?
      current_space.name
    else
      "Convene"
    end
  end

  helper_method :current_person

  # Overrides built in `url_for` to better support branded domains
  # @see http://api.rubyonrails.org/classes/ActionController/Metal.html#method-i-url_for
  helper_method def url_for(options)
    space = if options[0].try(:branded_domain).present?
      options.delete_at(0)
    elsif [:edit, :new].include?(options[0]) && options[1].try(:branded_domain).present?
      options.delete_at(1)
    elsif options.try(:branded_domain).present?
      options
    end

    return super unless space

    # Appends the domain to the options passed to `url_for`
    if options.respond_to?(:last) && options.last.is_a?(Hash)
      options.last[:host] = space.branded_domain
    elsif options.respond_to?(:<<) && options.length > 0
      options << {host: space.branded_domain}
    else
      options = [:root, {host: space.branded_domain}]
    end

    super
  end

  # Removes the root branded domain from the path builder
  # @see http://api.rubyonrails.org/classes/ActionDispatch/Routing/PolymorphicRoutes.html#method-i-polymorphic_path
  helper_method def polymorphic_path(record_or_hash_or_array, options = {})
    if record_or_hash_or_array[0].try(:branded_domain).present? && record_or_hash_or_array.length > 1
      record_or_hash_or_array.delete_at(0)
    elsif [:edit, :new].include?(record_or_hash_or_array[0]) && record_or_hash_or_array.try(:branded_domain).present?
      options.delete_at(1)
    end

    super
  end

  # @todo this should be tested 🙃 halp me
  def ensure_on_byo_domain
    return if current_space.blank?
    if request.get? && current_space.branded_domain.present? && request.host != current_space.branded_domain
      Rails.logger.debug { "Request Host: #{request.host}" }
      redirect_url = URI(request.url)
      redirect_url.host = current_space.branded_domain
      redirect_url.path = redirect_url.path.gsub("/spaces/#{current_space.slug}", "")
      Rails.logger.debug { "Redirecting from #{request.url}" }
      redirect_to redirect_url.to_s, allow_other_host: true if redirect_url != URI(request.url)
    end
  end

  def enforce_ssl
    return if current_space.blank?
    if request.get? && !request.ssl? && current_space.enforce_ssl.present?
      Rails.logger.debug { "Request Host: #{request.host}" }
      redirect_url = URI.parse(request.url)
      redirect_url.scheme = "https"
      Rails.logger.debug { "Redirecting from #{request.url}" }
      redirect_to redirect_url.to_s
    end
  end

  private

  OPERATOR_TOKEN = ENV["OPERATOR_API_KEY"]
  # @return [Guest, Person, Operator] the authenticated user, or a Guest
  def current_person
    return @current_person if defined?(@current_person)

    if api_request?
      authenticate_or_request_with_http_token do |token, _options|
        ActiveSupport::SecurityUtils.secure_compare(token, OPERATOR_TOKEN)
      end

      @current_person = Operator.new
    else
      @current_person ||= Person.find_by(id: session[:person_id]) || Guest.new
    end
  end

  def api_request?
    request.content_type == "application/json"
  end

  def pundit_user
    current_person
  end

  # Retrieves the space based upon the requests domain or params
  # @return [nil, Space]
  helper_method def current_space
    @current_space ||=
      if params[:space_id]
        space_repository.friendly.find(params[:space_id])
      else
        BrandedDomainConstraint.new(space_repository).space_for_request(request)
      end
  end

  helper_method def current_membership
    @current_membership ||= if current_space.present? && current_person.present?
      current_person.memberships.find_by(space: current_space)
    end
  end

  def space_repository
    policy_scope(Space.includes(:rooms, entrance: [:gizmos]))
  end

  # Retrieves the room based upon the current_space and params
  # @return [nil, Room]
  helper_method def current_room
    return nil if current_space.blank?

    @current_room ||=
      policy_scope(current_space.rooms).friendly.find(
        params[:room_id] || params[:id]
      )
  rescue ActiveRecord::RecordNotFound
    current_space.entrance
  end

  def handle_unauthorized(exception)
    render_not_found
  end

  def render_not_found
    render "errors/not_found", status: :not_found
  end

  helper_method def turbo_visit_control?
    turbo_visit_control.present?
  end

  helper_method def turbo_visit_control
    nil
  end
end

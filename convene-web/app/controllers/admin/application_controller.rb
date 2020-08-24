# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include Configuration::Configurable

    http_basic_authenticate_with configuration.basic_auth

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    def records_per_page
      params[:per_page] || 20
    end

    def find_resource(param)
      resources = scoped_resource.respond_to?(:friendly) ? scoped_resource.friendly : scoped_resource
      resources.find(param)
    end
  end
end

# frozen_string_literal: true

# Exposes CRUD actions for the {AuthenticationMethod} model.
class AuthenticationMethodsController < ApplicationController
  def create
    skip_policy_scope
    authentication_method = AuthenticationMethod.new(authentication_method_params)
    authorize(authentication_method)
    if authentication_method.save
      render json: authentication_method_as_json(authentication_method)
    else
      render json: render_errors(authentication_method), status: :unprocessable_entity
    end
  end

  private def render_errors(model)
    {
      errors: [{
        title: t('.failure'),
        detail: model.errors.full_messages.join('.')
      }]
    }
  end

  # @todo Maybe we want to try?
  #       http://jsonapi-rb.org/guides/serialization/defining.html
  private def authentication_method_as_json(authentication_method)
    {
      authentication_method: {
        id: authentication_method.id,
        contact_method: authentication_method.contact_method,
        contact_location: authentication_method.contact_location,
        person: {
          id: authentication_method.person.id
        }
      }
    }
  end

  def authentication_method_params
    params.require(:authentication_method).permit(:contact_method, :contact_location)
  end
end

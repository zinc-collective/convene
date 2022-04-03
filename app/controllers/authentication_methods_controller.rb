# frozen_string_literal: true

# Exposes CRUD actions for the {AuthenticationMethod} model.
class AuthenticationMethodsController < ApplicationController
  def create
    skip_policy_scope
    authentication_method = AuthenticationMethod.new(authentication_method_params)
    authorize(authentication_method)
    authentication_method.save!

    render json: {
      id: authentication_method.id,
      contact_method: authentication_method.contact_method,
      contact_location: authentication_method.contact_location,
      person: {
        id: authentication_method.person.id
      }
    }
  end

  def authentication_method_params
    params.require(:authentication_method).permit(:contact_method, :contact_location)
  end
end

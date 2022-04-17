# frozen_string_literal: true

# Exposes CRUD actions for the {AuthenticationMethod} model.
class AuthenticationMethodsController < ApplicationController
  def create
    skip_policy_scope
    authentication_method_params = policy(AuthenticationMethod).permit(params)
    authentication_method = AuthenticationMethod.new(authentication_method_params)
    authorize(authentication_method)
    if authentication_method.save
      render json: AuthenticationMethod::Serializer.new(authentication_method).to_json
    else
      render json: AuthenticationMethod::Serializer.new(authentication_method).to_json, status: :unprocessable_entity
    end
  end
end

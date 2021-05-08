class SessionsController < ApplicationController
  def create
  end

  def new
  end

  def destroy
  end

  helper_method def auth_session
    @auth_session ||= Session.new(request: request)
  end
end
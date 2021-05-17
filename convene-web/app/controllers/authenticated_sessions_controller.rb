class AuthenticatedSessionsController < ApplicationController
  def create
    redirect_to current_space if authenticated_session.save
  end

  def new
  end

  def destroy
    authenticated_session.destroy
    redirect_to current_space
  end

  helper_method def authenticated_session
    @authenticated_session ||= AuthenticatedSession.new(authenticated_session_params)
  end

  def authenticated_session_params
    params.fetch(:authenticated_session, {}).permit(:email_address, :one_time_password).merge(space: current_space, session: session)
  end
end
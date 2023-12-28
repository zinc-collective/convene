class AuthenticatedSessionsController < ApplicationController
  # Not a database-backed model, no need to policy-scope.
  skip_after_action :verify_policy_scoped

  def show
    redirect_to(current_space.presence || :root) if authenticated_session.save
  end

  def new
  end

  def create
    if authenticated_session.save
      redirect_to(current_space.presence || :root)
    else
      render :new, status: :unprocessable_entity
    end
  end

  alias_method :update, :create

  def destroy
    authenticated_session.destroy
    redirect_to(current_space.presence || :root)
  end

  helper_method def authenticated_session
    @authenticated_session ||= AuthenticatedSession.new(authenticated_session_params).tap do |authenticated_session|
      authorize(authenticated_session)
    end
  end

  def authenticated_session_params
    params.fetch(:authenticated_session, {})
      .permit(:authentication_method_id, :contact_method, :contact_location,
        :one_time_password)
      .merge(space: current_space, session: session)
  end
end

# frozen_string_literal: true

class ErrorsController < ApplicationController
  before_action :skip_authorization

  def turbo_visit_control
    :reload
  end

  def show
    render error_template, status: status_code
  end

  private

  def status_code
    @status_code ||=
      begin
        request.env["action_dispatch.exception"].try(:status_code) ||
          ActionDispatch::ExceptionWrapper.status_code_for_exception(request.env["action_dispatch.exception"])
      rescue => err
        Sentry.capture_exception(err)
        500
      end
  end

  def error_template
    (status_code == 404) ? "not_found" : "generic_error"
  end
end

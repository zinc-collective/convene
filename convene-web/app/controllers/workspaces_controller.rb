class WorkspacesController < ApplicationController
  before_action :require_person!
  def show
    @workspace = current_workspace
  end
end

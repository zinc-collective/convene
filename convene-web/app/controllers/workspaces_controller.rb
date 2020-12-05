class WorkspacesController < ApplicationController
  def show
    @workspace = current_workspace
  end
end

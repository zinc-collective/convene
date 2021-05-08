class SpacesController < ApplicationController
  def show; end

  helper_method def space
    @space ||= current_space
  end
end

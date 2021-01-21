class SpacesController < ApplicationController
  def show
    @space = current_space
  end
end

class SpacesController < ApplicationController
  def show
    @space = current_space
  end

  def edit
    @space = current_space
  end
end

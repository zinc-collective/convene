# frozen_string_literal: true

# Exposes CRUD actions on the {Space} model.
class SpacesController < ApplicationController
  def show; end

  def edit
  end

  def destroy
    space.destroy
  end

  helper_method def space
    @space ||= current_space.tap do |space|
      authorize(space)
    end
  end
end

# frozen_string_literal: true

# Exposes CRUD actions on the {Space} model.
class SpacesController < ApplicationController
  def show; end

  helper_method def space
    @space ||= current_space
  end
end

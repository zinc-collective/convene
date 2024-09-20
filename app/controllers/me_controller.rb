class MeController < ApplicationController
  def show
    authorize(current_person)

    render locals: {person: current_person}
  end
end

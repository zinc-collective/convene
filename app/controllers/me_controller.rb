class MeController < ApplicationController
  def show
    respond_to do |format|
      format.json { render json: current_person.as_json(root: :attributes) }
      format.html { render locals: {person: current_person} }
    end
  end
end

class MeController < ApplicationController
  def show
    respond_to do |format|
      format.json { render json: current_person }
    end
  end
end

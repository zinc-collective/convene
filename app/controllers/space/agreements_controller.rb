class Space
  class AgreementsController < ApplicationController
    def show
      authorize(agreement)
    end

    helper_method def agreement
      @agreement ||= policy_scope(space.agreements).friendly.find(params[:id])
    end

    def space
      current_space
    end
  end
end

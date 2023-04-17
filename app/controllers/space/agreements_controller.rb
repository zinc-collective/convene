class Space
  class AgreementsController < ApplicationController
    def show
    end

    def new
      agreement
    end

    def create
      agreement.save

      if agreement.errors.present?
        render :new, status: :unprocessable_entity
      else
        redirect_to space.location(:edit), notice: t(".success", name: agreement.name)
      end
    end

    helper_method def agreement
      @agreement ||= if params[:id]
        policy_scope(space.agreements).friendly.find(params[:id])
      elsif params[:agreement]
        space.agreements.new(agreement_params)
      else
        space.agreements.new
      end.tap { |agreement| authorize(agreement) }
    end

    def agreement_params
      policy(Agreement).permit(params.require(:agreement))
    end

    def space
      current_space
    end
  end
end

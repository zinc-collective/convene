class Space
  class AgreementsController < ApplicationController
    def show
    end

    def new
      agreement
    end

    def edit
    end

    def create
      if agreement.save
        redirect_to space.location(:edit), notice: t(".success", name: agreement.name)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if agreement.update(agreement_params)
        redirect_to space.location(:edit), notice: t(".success", name: agreement.name)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      agreement.destroy
      redirect_to space.location(:edit), notice: t(".success", name: agreement.name)
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

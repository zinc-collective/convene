# frozen_string_literal: true

class Marketplace
  class MarketplacesController < FurnitureController
    def show
    end

    def edit
      marketplace
    end

    def update
      if marketplace.update(marketplace_params)
        redirect_to marketplace.location(:edit), notice: t(".success")
      else
        flash[:alert] = t(".failure")
        render :edit, status: :unprocessable_entity
      end
    end

    helper_method def marketplace
      authorize(Marketplace.find(params[:id]))
    end

    def marketplace_params
      policy(Marketplace).permit(params.require(:marketplace))
    end
  end
end

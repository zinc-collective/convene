# frozen_string_literal: true

class Marketplace
  class MarketplacesController < Controller
    def show
      authorize(marketplace)
    end

    def edit
      authorize(marketplace)
    end

    def update
      if authorize(marketplace).update(marketplace_params)
        redirect_to marketplace.location(child: :notification_methods), notice: t(".success", name: marketplace.room.name)
      else
        render :edit
      end
    end

    def marketplace_params
      policy(Marketplace).permit(params.require(:marketplace))
    end
  end
end

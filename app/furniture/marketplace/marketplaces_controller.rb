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

        if marketplace_params[:square_access_token] || marketplace_params[:square_location_id]
          flash.notice = "Square notification settings updated succesfully!"
          flash.alert = "Square notification settings were not upated. Please try again or contact your site administrator."
        end
      else
        render :edit
      end
    end

    def marketplace_params
      policy(Marketplace).permit(params.require(:marketplace))
    end
  end
end

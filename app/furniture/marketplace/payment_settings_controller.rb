class Marketplace
  class PaymentSettingsController < FurnitureController
    def index
      authorize(marketplace, :edit?)
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end
  end
end

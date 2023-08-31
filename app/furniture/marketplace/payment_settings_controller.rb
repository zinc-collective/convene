class Marketplace
  class PaymentSettingsController < Controller
    def index
      authorize(marketplace, :edit?)
    end
  end
end

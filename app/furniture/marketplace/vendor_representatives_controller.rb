# frozen_string_literal: true

class Marketplace
  class VendorRepresentativesController < Controller
    expose :vendor_representative, scope: -> { vendor_representatives }, model: VendorRepresentative
    expose :vendor_representatives, -> { policy_scope(marketplace.vendor_representatives) }

    def new
      authorize(vendor_representative)
    end

    def create
      authorize(vendor_representative).save

      if vendor_representative.persisted?
        redirect_to marketplace.location(child: :vendor_representatives), notice: t(".success", email_address: vendor_representative.email_address)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def index
      skip_authorization
    end

    def update
      if authorize(vendor_representative).update(vendor_representative_params)
        redirect_to marketplace.location(child: :vendor_representatives), notice: t(".success", email_address: vendor_representative.email_address)

      else
        redirect_to marketplace.location(child: :vendor_representatives), notice: t(".failure", email_address: vendor_representative.email_address)

      end
    end

    def destroy
      authorize(vendor_representative).destroy
      redirect_to marketplace.location(child: :vendor_representatives), notice: t(".success", name: vendor_representative.email_address)
    end

    def vendor_representative_params
      policy(VendorRepresentative).permit(params.require(:vendor_representative))
    end
  end
end

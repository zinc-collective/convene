class Marketplace
  class DeliveryAreasController < Controller
    expose :delivery_area, model: DeliveryArea, scope: -> { delivery_areas }
    expose :delivery_areas, -> { policy_scope(marketplace.delivery_areas) }

    def index
      skip_authorization
    end

    def edit
      authorize(delivery_area)
    end

    def create
      if authorize(delivery_area).save
        redirect_to marketplace.location(child: :delivery_areas)
      else
        render :new
      end
    end

    def new
      authorize(delivery_area)
    end

    def update
      if authorize(delivery_area).update(delivery_area_params)
        redirect_to marketplace.location(child: :delivery_areas), notice: t(".success", name: delivery_area.label)
      else
        render :edit
      end
    end

    def destroy
      authorize(delivery_area)

      delivery_area.discard if !delivery_area.destroy_safely

      redirect_to marketplace.location(child: :delivery_areas)
    end

    def delivery_area_params
      policy(DeliveryArea).permit(params.require(:delivery_area))
    end
  end
end

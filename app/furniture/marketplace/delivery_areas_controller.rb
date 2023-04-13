class Marketplace
  class DeliveryAreasController < Controller
    def index
    end

    def edit
    end

    def create
      if delivery_area.save
        redirect_to marketplace.location(child: :delivery_areas)
      else
        render :new
      end
    end

    def new
      delivery_area
    end

    def update
      if delivery_area.update(delivery_area_params)
        redirect_to marketplace.location(child: :delivery_areas)
      else
        render :edit
      end
    end

    def delivery_area_params
      policy(DeliveryArea).permit(params.require(:delivery_area))
    end

    helper_method def delivery_area
      @delivery_area ||= if params[:id]
        delivery_areas.find(params[:id])
      elsif params[:delivery_area]
        delivery_areas.new(delivery_area_params)
      else
        delivery_areas.new
      end.tap do |delivery_area|
        authorize(delivery_area)
      end
    end

    helper_method def delivery_areas
      @delivery_areas ||= policy_scope(marketplace.delivery_areas)
    end
  end
end

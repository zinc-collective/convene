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

      if delivery_area.discarded?
        delivery_area.destroy if delivery_area.orders.empty?
      else
        delivery_area.discard
      end

      respond_to do |format|
        format.turbo_stream do
          if delivery_area.destroyed? || delivery_area.discarded?
            render turbo_stream: turbo_stream.remove(delivery_area)
          else
            render turbo_stream: turbo_stream.replace(delivery_area)
          end
        end

        format.html do
          if delivery_area.destroyed? || delivery_area.discarded?
            redirect_to marketplace.location(child: :delivery_areas)
          else
            render :show
          end
        end
      end
    end

    def delivery_area_params
      policy(DeliveryArea).permit(params.require(:delivery_area))
    end
  end
end

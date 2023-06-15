class Marketplace
  class OrderNotificationMethodsController < Controller
    def new
      order_notification_method
    end

    def edit
      order_notification_method
    end

    def update
      if order_notification_method.update(order_notification_method_params)
        redirect_to marketplace.location(child: :order_notification_methods), notice: t(".success", contact_location: order_notification_method.contact_location)
      else
        render :edit
      end
    end

    def create
      if order_notification_method.save
        redirect_to marketplace.location(child: :order_notification_methods)
      else
        render :new
      end
    end

    def destroy
      order_notification_method.destroy

      respond_to do |format|
        format.turbo_stream do
          if order_notification_method.destroyed?
            render turbo_stream: turbo_stream.remove(order_notification_method)
          else
            render turbo_stream: turbo_stream.replace(order_notification_method)
          end
        end
      end
    end

    helper_method delegate :order_notification_methods, to: :marketplace

    helper_method def order_notification_method
      if params[:id]
        order_notification_methods.find(params[:id])
      elsif params[:order_notification_method]
        order_notification_methods.new(order_notification_method_params)
      else
        order_notification_methods.new
      end.tap do |order_notification_method|
        authorize(order_notification_method)
      end
    end

    def order_notification_method_params
      policy(OrderNotificationMethod).permit(params.require(:order_notification_method))
    end
  end
end

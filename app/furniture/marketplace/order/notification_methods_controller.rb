class Marketplace
  class Order
    class NotificationMethodsController < Controller
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
          render :edit, status: :unprocessable_entity
        end
      end

      def create
        if order_notification_method.save
          redirect_to marketplace.location(child: :order_notification_methods)
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        order_notification_method.destroy

        redirect_to marketplace.location(child: :order_notification_methods), notice: t(".success", contact_location: order_notification_method.contact_location)
      end

      helper_method def order_notification_methods
        @order_notification_methods ||= marketplace.order_notification_methods
      end

      helper_method def order_notification_method
        @order_notification_method ||= if params[:id]
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
        policy(NotificationMethod).permit(params.require(:order_notification_method))
      end
    end
  end
end

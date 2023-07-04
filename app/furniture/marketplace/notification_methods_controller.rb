class Marketplace
  class NotificationMethodsController < Controller
    def new
      notification_method
    end

    def edit
      notification_method
    end

    def update
      if notification_method.update(notification_method_params)
        redirect_to marketplace.location(child: :notification_methods), notice: t(".success", contact_location: notification_method.contact_location)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      if notification_method.save
        redirect_to marketplace.location(child: :notification_methods)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      notification_method.destroy

      redirect_to marketplace.location(child: :notification_methods), notice: t(".success", contact_location: notification_method.contact_location)
    end

    helper_method def notification_methods
      @notification_methods ||= marketplace.notification_methods
    end

    helper_method def notification_method
      @notification_method ||= if params[:id]
        notification_methods.find(params[:id])
      elsif params[:notification_method]
        notification_methods.new(notification_method_params)
      else
        notification_methods.new
      end.tap do |notification_method|
        authorize(notification_method)
      end
    end

    def notification_method_params
      policy(NotificationMethod).permit(params.require(:notification_method))
    end
  end
end

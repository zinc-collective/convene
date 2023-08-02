class Marketplace
  class NotificationMethodsController < Controller
    expose :notification_method, model: NotificationMethod, scope: -> { notification_methods }
    expose :notification_methods, -> { policy_scope(marketplace.notification_methods) }

    def new
      authorize(notification_method)
    end

    def edit
      authorize(notification_method)
    end

    def update
      if authorize(notification_method).update(notification_method_params)
        redirect_to marketplace.location(child: :notification_methods), notice: t(".success", contact_location: notification_method.contact_location)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      # if notification_method.contact_method == 'square'
      # marketplace.update()
      if authorize(notification_method).save
        redirect_to marketplace.location(child: :notification_methods)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      authorize(notification_method).destroy

      redirect_to marketplace.location(child: :notification_methods), notice: t(".success", contact_location: notification_method.contact_location)
    end

    def notification_method_params
      policy(NotificationMethod).permit(params.require(:notification_method))
    end
  end
end

# frozen_string_literal: true

class PaymentForm
  class PaymentsController < FurnitureController
    def create
      return if payment.save

      render :new
    end

    def index
    end

    private def payment_params
      policy(payments.new).permit(params.require(:payment_form_payment))
    end

    # @returns [PaymentForm]
    helper_method def furniture
      room.furniture_placements.find_by(furniture_kind: "payment_form").furniture
    end

    helper_method def payment
      @payment ||= payments.new(payment_params)
    end

    helper_method def payments
      @payments ||= authorize policy_scope(furniture.payments)
    end
  end
end

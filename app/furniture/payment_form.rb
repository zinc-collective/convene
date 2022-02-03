# frozen_string_literal: true

# Allows a Space to receive Payments
# @see features/furniture/payment-form.feature
class PaymentForm
  include Placeable

  def self.append_routes(router)
    router.scope module: 'payment_form' do
      router.resource :payment_form, only: [:show] do
        router.resources :payments, only: %i[create index]
      end
    end
  end

  # @returns [ItemRepository<Payment>]
  def payments
    ItemRepository.new(type: Payment, item_records: placement.item_records, space: placement.space)
  end

  def link_token_for(person)
    utilities.plaid.create_link_token(person: person, space: placement.space)
  end
end

# frozen_string_literal: true

class PaymentForm
  # @todo Probably want to figure out how we can make this play well with the
  # {ActiveModel::Attributes::ClassMethods} API or something so we don't have
  # to define methods for each write/read for attributes :(.
  class Payment < Item
    before_validation :exchange_public_token_for_access_token_and_item,
                      if: -> { plaid_access_token.blank? && public_token.present? }

    attr_accessor :public_token
    validates :payer_name, presence: true
    validates :payer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :memo, presence: true
    validates :plaid_account_id, presence: true
    validates :plaid_item_id, presence: true

    READY_FOR_DEPOSIT = :ready_for_deposit
    UNCLEARED = :uncleared
    CLEARED = :cleared
    STATES = [READY_FOR_DEPOSIT, UNCLEARED, CLEARED].freeze

    %i[
      status
      plaid_item_id
      plaid_account_id
      account_description
      plaid_access_token
      payer_name
      payer_email
      amount
      memo
    ].each do |attribute|
      store_accessor :data, attribute
    end

    def status
      data['status']&.to_sym
    end

    def ready_for_deposit?
      status.blank? || status == READY_FOR_DEPOSIT
    end

    def uncleared?
      status == UNCLEARED
    end

    def cleared?
      status == UNCLEARED
    end

    def account_number
      auth_get.numbers.ach.find { |a| a.account_id == plaid_account_id }.account
    end

    def routing_number
      auth_get.numbers.ach.find { |a| a.account_id == plaid_account_id }.routing
    end

    def auth_get
      @auth_get ||= utilities.plaid.auth_get(access_token: plaid_access_token)
    end

    # When Linking an Account, Plaid provides a "Public" token, which is
    # exchanged for an "Access Token" and "Item ID".
    private def exchange_public_token_for_access_token_and_item
      response = utilities.plaid.exchange_public_token(public_token: public_token)
      self.plaid_access_token = response.access_token
      self.plaid_item_id = response.item_id
    end
  end
end

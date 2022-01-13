# frozen_string_literal: true

class CheckDropbox
  # @todo Probably want to figure out how we can make this play well with the
  # {ActiveModel::Attributes::ClassMethods} API or something so we don't have
  # to define methods for each write/read for attributes :(.
  class Check < Item
    def save
      exchange_public_token_for_access_token_and_item if plaid_access_token.blank? && public_token.present?
      return false unless valid?

      super
    end

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
    def status
      data['status']&.to_sym
    end

    def status=(status)
      data['status'] = status
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

    def plaid_item_id=(plaid_item_id)
      data['plaid_item_id'] = plaid_item_id
    end

    def plaid_item_id
      data['plaid_item_id']
    end

    def plaid_account_id=(plaid_account_id)
      data['plaid_account_id'] = plaid_account_id
    end

    def plaid_account_id
      data['plaid_account_id']
    end

    def account_description
      data['account_description']
    end

    def account_description=(account_description)
      data['account_description'] = account_description
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

    def plaid_access_token=(plaid_access_token)
      data['plaid_access_token'] = plaid_access_token
    end

    def plaid_access_token
      data['plaid_access_token']
    end

    def payer_name=(payer_name)
      data['payer_name'] = payer_name
    end

    def payer_name
      data['payer_name']
    end

    def payer_email=(payer_email)
      data['payer_email'] = payer_email
    end

    def payer_email
      data['payer_email']
    end

    def amount=(amount)
      data['amount'] = amount&.to_i
    end

    def amount
      data['amount']
    end

    def memo=(memo)
      data['memo'] = memo
    end

    def memo
      data['memo']
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

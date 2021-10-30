# frozen_string_literal: true

class CheckDropbox
  # @todo Probably want to figure out how we can make this play well with the
  # {ActiveModel::Attributes::ClassMethods} API or something so we don't have # to define methods for each write/read for attributes :(.
  class Check < Item
    # When Linking an Account, Plaid provides a "Public" token, which is
    # exchanged for an "Access Token" and "Item ID".
    #
    # Setting the public token takes care of that for us
    def public_token=(public_token)
      @public_token = public_token

      response = utilities.plaid.exchange_public_token(public_token: public_token)
      self.plaid_access_token = response.access_token
      self.plaid_item_id = response.item_id

      self.public_token
    end

    READY_FOR_DEPOSIT = :ready_for_deposit
    UNCLEARED = :uncleared
    CLEARED = :cleared

    STATES = [READY_FOR_DEPOSIT, UNCLEARED, CLEARED].freeze

    def status
      data['status']&.to_sym
    end

    def status=(status)
      data['status']=status
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

    attr_reader :public_token

    def plaid_item_id=(plaid_item_id)
      data['plaid_item_id'] = plaid_item_id
    end

    def plaid_item_id
      data['plaid_item_id']
    end

    def account_number
      utilities.plaid.account_number_for(access_token: plaid_access_token, item_id: plaid_item_id)
    end

    def routing_number
      utilities.plaid.routing_number_for(access_token: plaid_access_token, item_id: plaid_item_id)
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
      data['amount']&.to_i
    end

    def memo=(memo)
      data['memo'] = memo
    end

    def memo
      data['memo']
    end
  end
end
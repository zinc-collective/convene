module Furniture
  class CheckDropbox
    class Check < Item
      # When Linking an Account, Plaid provides a "Public" token, which is
      # exchanged for an "Access Token" and "Item ID".
      #
      # Setting the public token takes care of that for us
      def public_token=(public_token)
        @public_token = public_token

        response = utilities.plaid.exchange_public_token(public_token: public_token)
        self.access_token = response.access_token
        self.plaid_item_id = response.item_id

        self.public_token
      end

      attr_reader :public_token

      def plaid_item_id=(plaid_item_id)
        data['plaid_item_id'] = plaid_item_id
      end

      def plaid_item_id
        data['plaid_item_id']
      end

      def access_token=(access_token)
        data['access_token'] = access_token
      end

      def access_token
        data['access_token']
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
        data['amount'] = amount
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
    end
  end
end
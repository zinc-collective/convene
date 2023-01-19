# Marketplace

The Marketplace uses Stripe, we anticipate that we will want to use the "Connect then Transfer" workflow: https://stripe.com/docs/connect/collect-then-transfer-guide

1. Build the Workflow for connecting a Stripe Account
2. Checkout with Stripe Checkout, and include the payment_intent_data with a transfer_group: https://stripe.com/docs/api/checkout/sessions/create#create_checkout_session-payment_intent_data-transfer_group
3. Upon completion of Checkout, we transfer the Money: https://stripe.com/docs/connect/charges-transfers

## Testing with Stripe

Stripe provides test API keys and testing credit card numbers, see:
* https://stripe.com/docs/keys#obtain-api-keys
* https://stripe.com/docs/testing

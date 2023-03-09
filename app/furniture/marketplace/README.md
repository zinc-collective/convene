# Marketplace

## Human/Computer/Human Interaction Design

```mermaid
journey
  title Purchase Flow
  section Placing an Order
    Begins Shopping: 1: Shopper
    Adds Product to Cart: 1: Shopper
    Checks out Cart: 2: Shopper
    Makes Payment: 4: Payment Processor, Shopper
  section Fulfilling an Order
    Receives Order: 0: Vendor, Distributor
    Fulfills Order: 0: Vendor
    Delivers Order: 0: Distributor
    Receives Order: 0: Shopper
```

```mermaid
---
title: Shopper Begins Shopping
---
flowchart LR
  A([Shopper]) -- Visits --> B[Marketplace] -- Creates --> C[Cart]
```

```mermaid
---
title: Shopper Adds Product to Cart
---
flowchart LR
  A([Shopper]) -- Creates -->  B[CartProduct] --> C[Product]
  B[CartProduct] --> D[Cart]
```

1. `Shopper` links `Product`s to their `Cart` by creating a `CartProduct` record which keeps track of things like quantity, discounts, special requests, etc.

```mermaid
---
title: Shopper Goes Through Checkout Flow
---
flowchart LR
  A([Shopper]) -- goes to Checkout Page --> B[Checkout] -- directs to --> C[Distributor] --> D[Payment Processor]
```

2. `Shopper` creates a `Checkout`, which directs them to the `Distributor`'s Payment Processor (Stripe, for now).

```mermaid
---
title: Shopper Completes Checkout
---
flowchart LR
  C[Distributor] --> D[Payment Processor]
  D[Payment Processor] -- payment successful --> D[Payment Processor] -- redirects --> E[Convene Order Page]
```

3. `Shopper` completes the Payment Processor's flow, which directs them back to Convene and updates the `Checkout` with payment processor details.

4. `Shopper` is redirected to the `Order`, which represents the `Cart` to the `Shopper` in a read-only manner.

## Architecture

The Marketplace uses Stripe, we anticipate that we will want to use the "Connect then Transfer" workflow: https://stripe.com/docs/connect/collect-then-transfer-guide

1. Build the Workflow for connecting a Stripe Account
2. Checkout with Stripe Checkout, and include the payment_intent_data with a transfer_group: https://stripe.com/docs/api/checkout/sessions/create#create_checkout_session-payment_intent_data-transfer_group
3. Upon completion of Checkout, we transfer the Money: https://stripe.com/docs/connect/charges-transfers

## Testing with Stripe

Stripe provides test API keys and testing credit card numbers, see:
* https://stripe.com/docs/keys#obtain-api-keys
* https://stripe.com/docs/testing

### On Local Environments
You will need to use the [`stripe` cli](https://stripe.com/docs/stripe-cli) to forward events to your local server.

The `--forward-to` url can be found for a particular marketplace by using `polymorphic_url(marketplace.location(child: :stripe_events)` from within a controller or view debug session.

You will then need to update the `marketplace#stripe_webhook_endpoint_secret` to match the webhook secret provided by the stripe cli, via the Rails console or directly in the database.

For the "Connect to Stripe" flow to work, you will need to have a local development URL that is recognized by Stripe as "reachable". One way to do this is:
1. add `127.0.0.1 convene.local` to your `/etc/hosts`
2. add `convene.local` as the `branded_domain` to whatever Space you are using for testing
3. access the app locally through `convene.local:3000`, instead of `localhost`

### On Github CodeSpaces
If you are using a Github CodeSpace, you will want to mark the web-server port as `public` so that Stripe can send it events.

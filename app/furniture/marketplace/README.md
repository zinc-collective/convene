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
flowchart TD
    A[Shopper] -- 1. adds Products to Cart --> B(Product)  --> C(Cart)
    C(Cart) --> D[CartProduct]
    B(Product)  --> D[CartProduct] -. contains .- id1>quantity, discounts, etc]
    A[Shopper] -- 2. goes thru Checkout flow --> E(Checkout) --a.  process this payment --> F(Payment Processor)
    F(Payment Processor) -- b. Payment Successfully processed ----> E(Checkout)
    E(Checkout) -- c. updated with payment processor details --> E(Checkout)
    A[Shopper] -- 3. Successsfully purchased items in Cart --> G(Order) -.- id2>read-only Cart]
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
2. `Shopper` creates a `Checkout`, which directs them to the `Distributor`'s Payment Processor (Stripe, for now).
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

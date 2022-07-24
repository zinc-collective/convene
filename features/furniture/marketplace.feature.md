# Feature: Furniture: Marketplace!

Whether you're a farmers market or other local distributor, transactions between
local vendors and the community is the cornerstone of a strong regional economy.

A Marketplace connects producers, distributors and consumers in a single Space.
## Scenario: Place a Delivery Order
For now, our primary client is local owned and operated delivery
organizations, like [Piikup](https://piikup.com/) or
[Candlestick](https://www.candlestickcourier.com/).

These organizations serve as distributors for regional vendors, closing the
last-mile and keeping money flowing within the community.

- Given a "Piikup Marketplace" Space
- And a "Marketplace" Furniture in the Entrance Hall to "Piikup Marketplace" Space is configured with:
  | delivery_fee             | $6.99              |
  | order_notification_email | orders@piikup.org  |
  | stripe_account           | piikup-stripe-key  |
- And a Marketplace Vendor "Mandela Grocery" in the "Piikup Marketplace" Space has:
  | stripe_account                 | mandela-stripe-key         |
  | order_notification_email       | orders@mandelagrocery.coop |
- And the Marketplace Vendor "Mandela Grocery" offers the following Products in the "Piikup Marketplace" Space
  | name                 | price |
  | 1lb of Bananas       | $1.39 |
  | 32oz of Greek Yogurt | $7.99 |
- When a Guest places a Delivery Marketplace Order in the "Piikup Marketplace" Space for:
  | item                 | quantity | price |
  | 1lb of Bananas       | 4        | $5.56 |
  | 32oz of Greek Yogurt | 1        | $7.99 |
  | Delivery by Piikup   | 1        | $6.99 |
- Then the Guest is charged $20.54 for their Marketplace Order
- And the Marketplace Order placed by the Guest in the "Piikup Marketplace" Space is delivered to "orders@piikup.org"
- And the Stripe Account "piikup-stripe-key" receives a Payment of $6.99
- And the Marketplace Order placed by the Guest in the "Piikup Marketplace" Space is delivered to "orders@mandelagrocery.coop"
- And the Stripe Account "mandela-stripe-key" receives a Payment of $13.55

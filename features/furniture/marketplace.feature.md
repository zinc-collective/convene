`@unstarted` `@andromeda`

# Feature: Furniture: Marketplace!

Whether you're a farmers market or other local distributor, transactions between
local vendors and the community is the cornerstone of a strong regional economy.

A Marketplace connects producers, distributors and consumers in a single Space.

## Background
- Given a "Piikup Marketplace" Space
- And a "Marketplace" Furniture is in the Entrance Hall to the "Piikup Marketplace" Space
- And a Marketplace Vendor "Mandela Grocery" offers the following Products in the "Piikup Marketplace" Space
  | name                 | price |
  | 1lb of Bananas       | $1.39 |
  | 32oz of Greek Yogurt | $7.99 |
- And a Marketplace Vendor "Piikup" offers Delivery Services in the "Piikup Marketplace" Space for the Marketplace Vendor "Mandela Grocery" for $6.99

## Scenario: Place a Delivery Order
- When a Guest places a Delivery Marketplace Order in the "Piikup Marketplace" Space for:
  | item                 | quantity | price |
  | 1lb of Bananas       | 4        | $5.56 |
  | 32oz of Greek Yogurt | 1        | $7.99 |
  | Delivery by Piikup   | 1        | $6.99 |
- Then the Guest is charged $20.54 for their Marketplace Order
- And the Marketplace Vendor "Piikup" receives the Marketplace Order placed by the Guest in the "Piikup Marketplace" Space
- And the Marketplace Vendor "Piikup" receives a Payment of $6.99
- And the Marketplace Vendor "Piikup" receives the Marketplace Order placed by the Guest in the "Piikup Marketplace" Space
- And the Marketplace Vendor "Mandela Grocery" receives a Payment of $13.55

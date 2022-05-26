# Feature: Furniture: Delivery Order Form

Local Caterers and Delivery Companies partner to bring affordable, high-quality, local food right to your doorstep!

This piece of furniture is for the Delivery Company to provide folks who are near-by that a local caterer is setting up;
and if they want they can add their order and ?save some cash? (Need to check w/April re: most compelling hook).

`@unimplemented-steps` `@unstarted`
## Scenario: Offering a Delivery Order Form

- Given a "Delivery Order Form" Furniture in the Entrance Hall to "Dev's Deliveries" Space
- And a Space Member "dev@example.com" for "Dev's Deliveries" Space
- And a Delivery Order Form Menu "Zee's Munchies Merchants" is in "Dev's Deliveries" Space with the following Menu Items:
  | name | price | description | photo |
  | A God Damn Pizza | $8.95 | It's a 12" margherita: Tomato's, Moz, Basil. WARNING: Does NOT travel well. No refunds. | <pizza-photo> |
  | Some Mother Effin' Granola| $2.99 | Maple syrup, dried cranberries, cinnamon, cardamom, almonds, and oats. What more can you want?! | <granola-photo> |
- When the following Delivery Order Form is opened in Dev's Deliveries" Space by the Space Member "dev@example.com":
  | date | 2022-03-05 |
  | delivery_window | 11AM to 1PM |
  | menu | Zee's Munchies Merchants |
- Then a Delivery Order Form Order may be placed by Guests to the Entrance Hall to "Dev's Deliveries" Space

`@unimplemented-steps` `@unstarted`
## Scenario: Placing a Delivery Order Form Order

  - Given a "Delivery Order Form" Furniture in the Entrance Hall to "Dev's Deliveries" Space with the following configuration:
    | order_email | orders@devs-deliveries.example.com |
  - And a Delivery Order Form Menu "Zee's Munchies Merchants" is in "Dev's Deliveries" Space with the following Menu Items:
    | name | price | description | photo |
    | A God Damn Pizza | $8.95 | It's a 12" margherita: Tomato's, Moz, Basil. WARNING: Does NOT travel well. No refunds. | <pizza-photo> |
    | Some Mother Effin' Granola| $2.99 | Maple syrup, dried cranberries, cinnamon, cardamom, almonds, and oats. What more can you want?! | <granola-photo> |
- And the following Delivery Order Form is open in Dev's Deliveries" Space:
  | name | Downtown Oakland! Get Your Munchies! |
  | date | 2022-03-05 |
  | delivery_window | 11AM to 1PM |
  | menu | Zee's Munchies Merchants |
- When the following Delivery Order Form Order is placed by the Guest "a-rando@example.com" in "Dev's Deliveries" Space:
  | popup | Downtown Oakland! Get Your Munchies! |
  | item[] | { "name": "A God Damn Pizza", price: "$8.95" } |
  | delivery_fee | $2.95 |
  | deliver_to | "123 N West St, Oakland, CA 94612 |
- Then a Delivery Order Form Payment of $11.90 is collected from the Guest "A-rando@example.com" in "Dev's Deliveries" Space
- And the following Delivery Order Form Order Confirmation Email is sent to "orders@devs-deliveries.example.com"

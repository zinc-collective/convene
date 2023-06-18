Feature: Boops

  Note: `Furniture` has been renamed to `Gizmo/Gizmos`.

  In order to equitably invoice for the costs incurred in providing co-owned digital infrastucture
  Operators want a way to account for costs of interactions/behaviors/etc.

  Boops ("Bytes Or OPerationS") serve as a cost-unit, similar to KW/h for electricity, that allow Space Owners to only
  pay for what they  actually use in the Convene Neighborhood.

  Cost for Boops is set by the Operators of the Convene Neighborhood, and the cost-in-boops for particular events is
  set by Maintainers of the particular pieces of Furniture and Utilities.

  By decoupling from particular currencies, we make it easy to account for really low "cost" things, that still have a
  cost as well as make it possible to operate a Convene Neighborhood without being tied to USD (or even local
  currencies).

  Admittedly this abstraction can make things more complicated; but my hope is that it's a useful one for giving
  affordances for decision making about how much to charge for what without making the stakes super high.

  Plus it's fun to say. Boop. Boop. Boopboopboop.

  @unimplemented-steps
  Scenario: Monthly Space Fees
    Given a "Personal Website" Space
    And the "Personal Website" Space has 5,000 Boops
    And the Operators set the Daily Space Rental to 5 Boops
    When a Day passes
    Then the "Personal Website" Space has 4,995 Boops remaining
    And the Boop Log for the "Personal Website" Space has a

  @unimplemented-steps
  Scenario: Filling Boops
    Given a "Personal Website" Space
    And the "Personal Website" Space has 100 Boops
    And the Operators have set the Boops price at 1,000 Boops for $1
    When a $5 Boops Payment is made for the "Personal Website" Space
    Then the "Personal Website" Space has 5,100 Boops

  @unimplemented-steps
  Scenario: Reviewing Boop Spend History
    Given a "Personal Website" Space
    And the Boop Spends for the "Personal Website" Space are as follows:
      | spender        | spender type | amount | reason                              | date       |
      | 8x8 Jitsi SaaS | Utility      | 150    | 3 MAUs on Jan 3rd 2022              | 2022-01-03 |
      | VideoBridge    | Furniture    | 10     | 3 MAUs on Jan 3rd 2022              | 2022-01-03 |
      | PaymentForm    | Furniture    | 10     | Payment received                    | 2022-01-03 |
      | Neighborhood   | Space        | 50     | Monthly Hosting Fee (personal site) | 2022-01-31 |
      | PaymentForm    | Furniture    | 10     | Total Payments Stored in January    | 2022-01-31 |
    When the Operator for the "Personal Website" Space reviews Boops spent in January
    Then the Operator for the "Personal Wesbsite" Space can see there were 230 Boops Spent in January 2022
    And the Operator for the "Personal Website" space can see the following Boop Spends
      | spender        | spender type | amount | reason                              | date       |
      | 8x8 Jitsi SaaS | Utility      | 150    | MAUs on Jan 3rd 2022                | 2022-01-03 |
      | VideoBridge    | Furniture    | 10     | MAUs on Jan 3rd 2022                | 2022-01-03 |
      | PaymentForm    | Furniture    | 10     | Payment received                    | 2022-01-03 |
      | Neighborhood   | Space        | 50     | Monthly Hosting Fee (personal site) | 2022-01-31 |
      | PaymentForm    | Furniture    | 10     | Total Payments Stored in January    | 2022-01-31 |

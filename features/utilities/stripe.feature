Feature: Utilities: Stripe
  In order to sell things or acccept payments
  I want to leverage Stripe in my Space

  # @see https://stripe.com/
  @unstarted @milestone-a
  Scenario: Configuring the Stripe Utility
    Given a Space with a Stripe Utility
    When a Space Owner sets the following Configuration for that Utility
      | field           | value                     |
      | publishable_key | a-publishjable-stripe-key |
      | secret_key      | a-secret-stripe-key       |
    Then the Stripe Utility is Ready FFor Use

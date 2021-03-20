Feature: Hookups: Stripe
  In order to sell things or acccept payments in my Space
  I want to Hookup Stripe to my Space

  # @see https://stripe.com/
  @unstarted @milestone-a
  Scenario: Configuring the Stripe Hookup
    Given a Space with a new Stripe Hookup
    When a Space Owner sets the following Configuration for that Hookup
      | field           | value                     |
      | publishable_key | a-publishjable-stripe-key |
      | secret_key      | a-secret-stripe-key       |
    Then the Stripe Hookup is Ready to Use
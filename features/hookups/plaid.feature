Feature: Hookups: Plaid
  In order to support interactions with Space Members Financial Institutions
  I want to Hookup Plaid to my Space

  @unstarted @milestone-a
  Scenario: Configuring the Plaid Hookup
    Given a Space with a new Plaid Hookup
    When a Space Owner sets the following Configuration for that Hookup
      | field        | value                   |
      | client_id    | plaid_sandbox_client_id |
      | plaid_secret | plaid_sandbox_secret    |
      | env          | sandbox                 |
    Then the Plaid Hookup is Ready to Use
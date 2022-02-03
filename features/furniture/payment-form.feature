Feature: Payment Form
  In order to reduce transaction fees when accepting large payments
  As a Space Owner
  I would like to accept Payments


  # At present, we're exploring using [Plaid Link] and [Plaid Auth] as the
  # mechanism for collecting and verifying ACH details. They have provided
  # a particularly nice [Modern Guide to ACH].
  #
  # Because we do not store any financial account data, we should be compliant
  # with [PCI DSS].
  #
  # There are two primary use-cases here:
  #
  # 1. Dropping off a check for (eventual) deposit
  # 2. Providing the checks to the Space Owner
  #
  # At present, we are _not_ automating the ACH transfer, though there are many
  # [Payment Processor integrations for Plaid]. Instead, we are opting to
  # expose a [NACHA file], which can be uploaded to many financial institutions
  # business portals.
  #
  # [Plaid Link]: https://plaid.com/docs/link/
  # [Plaid Auth]: https://plaid.com/docs/auth/
  # [Plaid Auth API Docs]: https://plaid.com/docs/api/products/#auth
  # [Payment Processor integrations for Plaid]: https://plaid.com/docs/auth/#using-a-payment-processor
  # [Modern Guide to ACH]: https://go.plaid.com/rs/495-WRE-561/images/Plaid-Modern-guide-to-ACH.pdf
  # [PCI DSS]: https://en.wikipedia.org/wiki/Payment_Card_Industry_Data_Security_Standard
  # [NACHA file: https://files.nc.gov/ncosc/documents/eCommerce/bank_of_america_nacha_file_specs.pdf
  Background:
    Given a Space with a Room with Check Drop Off Furniture fully configured

  # For valid link credentials data, see https://plaid.com/docs/auth/coverage/testing/#testing-the-link-flow
  @unstarted
  Scenario: Dropping off an Electronic Check with a Valid Bank Account
    Given a Guest begins the Check Deposit Workflow with the following data:
      | check_amount          | $1000                     |
      | earliest_deposit_date | 1 week from now           |
      | memo                  | Initial investment amount |
      | email                 | person@example.com        |
      | name                  | Person McMoney            |
      | signature             | Person McMoney            |
    When a Guest completes the Plaid Link Workflow with valid credentials
    Then the Space Owner's Pending Check's list includes the Check
    And the Space Owner's Pending Checks NACHA file looks like:
      """
      lol i don't know i need to look the file format up
      """
    And the Guest receives an Email letting them know that their Check is Pending Deposit

  @unstarted
  Scenario: Depositing Pending Checks from the Check Drop Box
    Given there are Pending Checks in the Check Drop Box
    When a Space Owner downloads the Pending Checks
    Then the downloaded NACHA file file looks like
      """
      lol i don't know this yet either
      """
    And the Check Drop Box has no Pending Checks
    And the Check Drop Box has the formerly pending checks Deposited
    And the Depositors receive an email letting them know their Check is being deposited.


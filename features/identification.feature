@unimplemented
Feature: Identification
  In order to assert my personal rights within a Space
  I want to Identify myself

  Identity within Convene serves three roles:
  1. Authenticating the Person using Convene for permissioning purposes.
  2. Allowing People to choose how they present themselves within a Space.
  3. Identifying People on Convene to other systems that support Remote Identity (such as through SAML, OAuth, OpenID, WebID or IndieAuth)


  Scenario: Identifying Via Email
    When a Guest requests to Identify themselves via Email
    Then the Guest can Identify themselves by entering a code sent to their Email
    And the Guest can Identify themselves by following a link sent to their Email

  Scenario: Identifying People with Multiple Email Addresses
    Given an Identified User adds an additional Email Address
    When the Identified User confirms that Email Address
    Then the Identified User may Identify themselves using that Email Address

  Scenario: Email Identification Code Times Out
    Given a Guest reuqests to Identify themselves via Email
    When I wait a an hour
    Then I am not identified within the space when I enter the code
    Then I am not identified within the space when I follow the link

  Scenario: Inactivity Sign Out
    Given an Identified User has been Inactive for 7 days
    When they visit Convene
    Then they are a Guest
    And their Session is ended

  Scenario: Manual Sign Out
    When an Identified User Signs Out
    Then they are a Guest
    And their Session is ended
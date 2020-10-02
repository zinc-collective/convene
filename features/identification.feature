@unstarted
Feature: Identification
  In order to assert my personal rights within a Space
  I want to Identify myself

  Identity within Convene serves three roles:
  1. Authenticating the Person using Convene for permissioning purposes.
  2. Allowing People to choose how they present themselves within a Space.
  3. Identifying People on Convene to other systems that support Remote Identity (such as through SAML, OAuth, OpenID, WebID or IndieAuth)


  Scenario: Identifying Via Email
    When a Guest requests to Identify themselves via Email
    Then the Guest can Identify themselves by entering the code sent to their Email
    And the Guest can Identify themselves by following the link sent to their Email

  Scenario: Identifying People with Multiple Email Addresses
    Given an Identified User adds an additional Email Address
    When the Identified User confirms that Email Address
    Then the Identified User may Identify themselves using that Email Address

  Scenario: Email Identification Code Times Out
    Given a Guest reuqests to Identify themselves via Email
    When the Guest waits for an hour
    Then the Guest can not Identify themselves by entering the code sent to their Email
    And the Guest can not Identify themselves by following the link sent to their Email

  Scenario: Inactivity Sign Out
    Given an Identified User has been Inactive for 7 days
    When they visit Convene
    Then they are a Guest
    And their Session is ended

  Scenario: Manual Sign Out
    When an Identified User Signs Out
    Then they are a Guest
    And their Session is ended

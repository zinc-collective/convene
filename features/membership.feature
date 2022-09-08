Feature: Membership
  In order to build a more coherent community
  As a Owner
  I want other people to participate in the space

  @unimplemented-steps @andromeda
  Scenario: Revoking Membership
    Given the "Super Fun Club" Space has a Member "gonna-bite-it@example.com"
    And the "Super Fun Club" Space has a Member "stick-around@example.com"
    When the Member "stick-around@example.com" removes the Member "gonna-bite-it@example.com" from the "Super Fun Club" Space
    Then the Member "stick-around@example.com" can find the Revoked Member "gonna-bite-it@example.com" in the Space Roster's Revoked Members Section
    And the Neighbor "gonna-bite-it@example.com" can still sign in to the "Super Fun Club" Space
    And the Neighbor "gonna-bite-it@example.com" is not a Member of the "Super Fun Club" Space
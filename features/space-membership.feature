Feature: Space membership
  In order to build a more coherent community
  As a Space owner
  I want to other people to participate in the space

  @unstarted @andromeda
  Scenario: Removing Space Members
    Given a Space with multiple Space Members
    When the Space Owner removes a Space Member
    Then that Space Member receives a Space Membership Revoked Email
    And the Space Member can still sign in
    And the Space Member is not a member of that Space
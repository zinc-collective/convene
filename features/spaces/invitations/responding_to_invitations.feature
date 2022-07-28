Feature: Spaces: Invitations: Responding to Invitations
  Once an Invitation is sent, it can be responded to. This allows the Invitee to:
  - Accept the Invitation and become a Member of the Space
  - Prevent further Invitations from the Space

  Background:
    Given a "Team Avatar" Space
    And the "Team Avatar" Space has a Space Owner "appa@example.com"

  @built @andromeda
  Scenario: Accepting an Invitation as the invited Un-Authenticated Neighbor
    Given a "Water Tribe" Space
    And the "Water Tribe" Space has a Space Owner "katara@example.com"
    And an Invitation to the "Team Avatar" Space is sent by Space Owner "appa@example.com"
      | name   | email              |
      | Katara | katara@example.com |
    When the Invitation to "katara@example.com" for the "Team Avatar" Space is accepted by the Neighbor "katara@example.com"
    Then the Neighbor "katara@example.com" becomes a Space Member of the "Team Avatar" Space
    Then the Invitation to "katara@example.com" for the "Team Avatar" Space has a status of "accepted"

  @built @andromeda
  Scenario: Accepting an Invitation as the invited Authenticated Neighbor
    Given a "Water Tribe" Space
    And the "Water Tribe" Space has a Space Owner "katara@example.com"
    And an Invitation to the "Team Avatar" Space is sent by Space Owner "appa@example.com"
      | name   | email              |
      | Katara | katara@example.com |
    And the Neighbor "katara@example.com" is signed in to the "Team Avatar" Space
    When the Invitation to "katara@example.com" for the "Team Avatar" Space is accepted by the Neighbor "katara@example.com"
    Then the Neighbor "katara@example.com" becomes a Space Member of the "Team Avatar" Space
    Then the Invitation to "katara@example.com" for the "Team Avatar" Space has a status of "accepted"

  @built @andromeda
  Scenario: Accepting an Invitation as the un-invited Un-Authenticated Neighbor
    Given a "Fire Nation" Space
    And the "Fire Nation" Space has a Space Owner "ozai@example.com"
    And an Invitation to the "Team Avatar" Space is sent by Space Owner "appa@example.com"
      | name   | email              |
      | Katara | katara@example.com |
    When the Invitation to "katara@example.com" for the "Team Avatar" Space is accepted by the Neighbor "ozai@example.com"
    Then the Neighbor "katara@example.com" does not become a Space Member of the "Team Avatar" Space
    And the Neighbor "ozai@example.com" does not become a Space Member of the "Team Avatar" Space
    # And the Invitation to "katara@example.com" for the "Team Avatar" Space has a status of "invited"

  @built @andromeda
  Scenario: Accepting an Invitation as the un-invited Authenticated Neighbor
    Given a "Fire Nation" Space
    And the "Fire Nation" Space has a Space Owner "ozai@example.com"
    And an Invitation to the "Team Avatar" Space is sent by Space Owner "appa@example.com"
      | name   | email              |
      | Katara | katara@example.com |
    And the Neighbor "ozai@example.com" is signed in to the "Team Avatar" Space
    When the Invitation to "katara@example.com" for the "Team Avatar" Space is accepted by the Neighbor "ozai@example.com"
    Then the Neighbor "katara@example.com" does not become a Space Member of the "Team Avatar" Space
    And the Neighbor "ozai@example.com" does not become a Space Member of the "Team Avatar" Space
    # And the Invitation to "katara@example.com" for the "Team Avatar" Space has a status of "invited"

  @built @andromeda
  Scenario: Accepting an Invitation as the invited Guest
    Given an Invitation to the "Team Avatar" Space is sent by Space Owner "appa@example.com"
      | name | email            |
      | Zuko | zuko@example.com |
    When the Invitation to "zuko@example.com" for the "Team Avatar" Space is accepted by the Guest "zuko@example.com"
    Then the Guest "zuko@example.com" becomes a Space Member of the "Team Avatar" Space
    And the Invitation to "zuko@example.com" for the "Team Avatar" Space has a status of "accepted"


  @unstarted @unimplemented-steps
  Scenario: Accepting an Invitation accepts all other outstanding invitations to that Guest
  # @todo implement me! At present, the invitations just stick around as pending; but they probably shouldn't!
  # And all other Invitations to Space Member "a-guest@example.com" for the "System Test" Space no longer have a status of "pending"

  # We want to make sure that people who were invited but
  # didn't take action can't suddenly appear and disorient
  # or potentially disrupt the people who are in the Space.
  @built @andromeda @unimplemented-steps
  Scenario: Responding to an Expired Invitation
    Given an Invitation was sent 15 days ago
    Then that Invitation is Expired
    And that Invitation cannot be Accepted



  # We want to demonstrate that we care about folks having the
  # affordances to prevent harassment or spam; so we want to provide
  # an explicit option to block further invitations from the Space
  @unstarted @andromeda
  Scenario: Blocking Further Invitations

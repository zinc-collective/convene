Feature: Spaces: Moderation


  @unstarted @andromeda
  Scenario: Removing Space Members
    Given a "System Test" Space
    And the "System Test" Space has a Space Owner "space-owner@example.com"
    And the "System Test" Space has a Space Member "bad-actor@example.com"
    And an Invitation to the "System Test" Space is sent by Space Member "bad-actor@example.com"
      | name | email                       |
      | Aang | aang-the-avatar@example.com |
    And an Invitation to the "System Test" Space is sent by Space Member "bad-actor@example.com"
      | name | email                       |
      | Katara | katara-the-waterbender@example.com |
    And an Invitation to "aang-the-avatar@example.com" the "System Test" Space is accepted
    When the Space Member "bad-actor@example.com" is removed from the "System Test" Space by the Space Owner "space-owner@example.com"
    # We thought that maybe instead of explicitely removing invitations and members, we would
    # start by letting them know who else that person invited.
    Then the Space Owner "space-owner@example.com" is encouraged to investigate the Space Member "aang-the-avatar@example.com"
    Then the Space Owner "space-owner@example.com" is encouraged to investigate the Invitation to "katara-the-waterbender@example.com"

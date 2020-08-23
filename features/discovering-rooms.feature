Feature: Discovering Rooms
  In order to interact with other people in a Workspace
  I want to be able to explore the Workspace's rooms

  @built @unimplemented-steps
  Scenario: Workspace Member may discover Listed Room
    Given a Workspace with a Listed Room
    When a Workspace Member is on the Workspace Dashboard
    Then they see the Room

  @built @unimplemented-steps
  Scenario: Guest may discover Listed Room
    Given a Workspace with a Listed Room
    When a Guest is on the Workspace Dashboard
    Then they see the Room

  @unstarted
  Scenario: Guest may not discover Listed Internal Room
    Given a Workspace with an Listed Internal Room
    When a Guest is on the Workspace Dashboard
    Then they do not see the Room

  # Unlisted Rooms

  @built
  Scenario: Guest may not discover Unlisted Rooms
    Given the Guest is on the "System Test" Workspace Dashboard
    Then the Guest does not see the "Unlisted Room 1" Room's Door

  @built
  Scenario: Workspace Member may not discover Unlisted Room
    Given the Workspace Member is on the "System Test" Workspace Dashboard
    Then the Workspace Member does not see the "Unlisted Room 1" Room's Door

  @unstarted @unimplemented-steps
  Scenario: Room Creator may discover Unlisted Room
    Given a Workspace with an Unlisted Room
    When the Room Creator is on the Workspace Dashboard
    Then they see the Room


  @unstarted
  Scenario: Room Previous Attendee may discover previously visited Unlisted Room
    Given a Workspace with an Unlisted Room
    When a Previous Attendee of that Room is on the Workspace Dashboard
    Then they see the Room